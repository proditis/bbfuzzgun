# BBFuzzGun
A small container with tools offensive security tools to test https://github.com/echoCTF/echoCTF.RED before each release.

The initial idea for this was born out of the necesity to fuzz our projects before release in a context that not only discovers vulnerabilities but also misconfigurations, errors and crashes.

## What this container does
* Checks nginx configurations that are passed as volumes under **`/checks/nginx/`** folder (eg `-v ./local/nginx.conf:/checks/nginx/some.conf`)
* Checks with `ffuf` the main url + given url lists
* performs paramspider
* performs phpcs security checks
* 

## How to run
```shell
docker run -it --rm \
-v $PWD/files/participantUI.conf.j2:/checks/nginx/participantUI.conf:ro \
-v $PWD/files/moderatorUI.conf.j2:/checks/nginx/moderatorUI.conf:ro \
-v $PWD/reports:/checks/reports \
bbfuzzgun /start.sh -H "Host: echoctf.local" https://192.168.1.25FUZZ
```

## Included Tools
* Leaky Paths wordlists
* smuggler.py (https://github.com/gwen001/pentest-tools)
* ParamSpider https://github.com/devanshbatham/ParamSpider/
* FFuF https://github.com/ffuf/ffuf/
* Dirdar https://github.com/m4dm0e/dirdar@latest
* subfinder https://github.com/subfinder/subfinder@latest
* arjun
* gixy
* https://github.com/FloeDesignTechnologies/phpcs-security-audit.git

## Admin helpers
Query to convert platform URL's to fuzzable endpoint urls

```sql
select regexp_replace(source,'(<(.)+>)','FUZZ') from url_route;
```
