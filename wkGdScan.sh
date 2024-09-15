#!/bin/bash

BLUE='\033[34m'
NC='\033[0m' # No Color

if [ "$1" = "-u" ]; then
    URL="$2"
    shift 2
else
    echo -e "${BLUE}Usage: $0 -u <URL>${NC}"
    exit 1
fi

echo -e "${BLUE}正在进行对目标站点进行基础信息收集...${NC}"
./waybackurls/waybackurls "$URL" > 2223.txt

echo -e "${BLUE}正在对目标站点进行深度爬虫...${NC}"
cat 2223.txt | ./katana_1.1.0/katana -jc >> Enpoints.txt

echo -e "${BLUE}正在检查响应中被反射的参数...${NC}"
cat Enpoints.txt | ./Gxss_4.1/Gxss -p khXSS -o XSS_Ref.txt

echo -e "${BLUE}正在进行xss漏洞扫描并保存结果中...${NC}"
./dalfox_2.9.3/dalfox file XSS_Ref.txt -o Vulnerable_XSS.txt

mkdir -p result
mv Vulnerable_XSS.txt result/scanResult.txt

echo -e "${BLUE}稍等一下下...${NC}"
rm 2223.txt Enpoints.txt XSS_Ref.txt

echo -e "${BLUE}扫描完成！！结果请查看文件：result/scanResult.txt.${NC}"
