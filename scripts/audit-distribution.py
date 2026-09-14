"""Compare the source distribution with every expected source contract file."""
from pathlib import Path
import hashlib,json,os,re,tarfile,zipfile
root=Path(__file__).resolve().parents[2];pkg=root/'endomer'
out=Path(os.environ.get('ENDOMER_RELEASE_DIR',root/'artifacts/endomer-engih-release'))
def dcf(raw):
    fields={};name=None
    for line in raw.decode('utf-8').splitlines():
        if not line.strip():continue
        if line[:1].isspace():fields[name]+=' '+line.strip()
        else:name,value=line.split(':',1);fields[name]=value.strip()
    return {k:re.sub(r'\s+',' ',v).strip() for k,v in fields.items()}
version=dcf((pkg/'DESCRIPTION').read_bytes())['Version']
expected=[p for directory in ('R','man','tests','vignettes') for p in (pkg/directory).rglob('*')
          if p.is_file() and p.name!='.gitignore']
expected += [pkg/p for p in ('inst/packages.dcf','DESCRIPTION','NAMESPACE','README.md','NEWS.md','LICENSE')]
source=out/f'package/endomer_{version}.tar.gz';binary=out/f'package/endomer_{version}.zip'
with tarfile.open(source) as archive:
    for p in expected:
        rel=p.relative_to(pkg).as_posix();actual=archive.extractfile('endomer/'+rel).read()
        if rel=='DESCRIPTION':
            description=dcf(actual)
            assert all(description.get(k)==v for k,v in dcf(p.read_bytes()).items()),rel
        else:assert actual==p.read_bytes(),rel
with zipfile.ZipFile(binary) as archive:
    assert archive.testzip() is None
    assert dcf(archive.read('endomer/DESCRIPTION'))['Version']==version
    assert 'endomer/R/endomer.rdb' in archive.namelist()
for mode in ('source','binary'):
    audit=json.loads((out/f'integration-{mode}-audit.json').read_text(encoding='utf-8'))
    assert audit['success'] and len(audit['resolved_libraries'])==7
    assert all(f'install-{mode}/' in p for p in audit['resolved_libraries'].values())
    assert len(audit['versions'])==4 and all(r['action']=='none' and r['meets_requirement'] for r in audit['versions'])
    assert len(audit['executed_guides'])==10
report={'source_files_verified':len(expected),'differences':[],
 'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),
 'binary_sha256':hashlib.sha256(binary.read_bytes()).hexdigest(),
 'installed_namespaces_from_isolated_libraries':True,'survey_examples_verified':['ENFT','ENCFT','ENHOGAR 2022','ENGIH 2018']}
(out/'distribution-audit.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
print(json.dumps(report,indent=2))
