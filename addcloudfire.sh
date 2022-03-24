echo "Sengkelat Tools Cloudflare"
read -p "Masukan File Path: " filemu
read -p "Masukan Email: " email
read -p "Masukan Apikey Global: " apikey
read -p "Masukan Id Akun: " idmu
read -p "Masukan IP Tujuan: " ip
read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
for domain in $(cat $filemu); 
do
adddomainid=$(curl --silent -X POST -H "X-Auth-Key: '$apikey'" -H "X-Auth-Email: '$email'"   -H "Content-Type: application/json"   "https://api.cloudflare.com/client/v4/zones"   --data '{"account": {"id": "'$idmu'"},"name":"'$domain'","jump_start":true}' | jq -r '.result.id'); 
#echo $adddomainid;
dona=$(curl --silent  -X POST "https://api.cloudflare.com/client/v4/zones/${adddomainid}/dns_records"  -H "X-Auth-Email: '$email'"  -H "X-Auth-Key: '$apikey'" -H "Content-Type: application/json"  --data '{"type":"A","name":"'$domain'","content":"'$ip'","ttl": 1,"priority":10,"proxied":true}'| jq -r '.success')
if [ "$dona" == "true" ]; then
echo "Success ${domain}"
else
echo "Failed ${domain}"
fi
done
