**# Origins**

**Origins** – A Tool to Help You Find Your Origin    
by **Youssef Alhomaimy (Homaimyy)**  

Origins is a simple Bash tool that integrates with the **VirusTotal API**, **httpx-toolkit**, and **wafw00f** to help you discover the **origin IPs** behind domains.    
It is designed for bug bounty hunters, pentesters, and researchers who want a quick way to uncover infrastructure details.

---

**## ✨ Features**  
- Query VirusTotal for domain IP addresses    
- Run automatic **WAF detection** with [wafw00f](https://github.com/EnableSecurity/wafw00f)    
- Scan IPs with [httpx-toolkit](https://github.com/projectdiscovery/httpx) for response codes, titles, and server details    
- Save results to file (`-o`)    
- Easy first-time setup with `init`    
- Clean colored terminal output  

---

**## 📦 Dependencies**  
Origins relies on:  
- `curl`  
- `jq`  
- `wafw00f`  
- `httpx-toolkit`

The script will automatically check and prompt you to install any missing dependencies.

---

**## ⚙️ Installation**  
\`\`\`bash  
git clone https://github.com/<yourusername\>/Origins.git  
cd Origins  
chmod \+x Origins.sh

---

**## 🚀 Usage**  
**1. Initialize with your VirusTotal API key**  
./Origins.sh init \<YOUR\_API\_KEY\>  
This saves your API key into \~/.origins\_config for later use.

**2. Query a domain**  
./Origins.sh -d [example.com](http://example.com)

**3. Save results to a file**  
./Origins.sh \-d example.com \-o results.txt

**4. Show help menu**  
./Origins.sh \-h

—

**## 📖 Example Output**  
   `██████╗`  
  `██╔═══██╗`  
  `██║   ██║`  
  `██║   ██║`  
  `╚██████╔╝`  
   `╚═════╝   by Homaimyy`

`[*] Running WAF detection on example.com...`  
`[*] WAF detected: Cloudflare`

`[+] Querying VirusTotal for example.com...`  
`104.21.12.34   [200] [nginx] [Example Domain]`  
`172.67.220.45  [403] [cloudflare] [Access Denied]`

**## ⚠️ Disclaimer**

`This tool is for educational and authorized security testing only.`  
 `The creator assumes no responsibility for misuse or illegal activity.`

**## 🧑‍💻 Author**

**`Youssef Alhomaimy (Homaimyy)`**  
 `Pentester • Bug Hunter • Security Researcher`

