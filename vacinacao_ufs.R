library(tidyverse)
library(rvest)
library(curl)
library(writexl)

#horario
Sys.time()

#scrapping da pagina
html_data<-read_html('https://opendatasus.saude.gov.br/dataset/covid-19-vacinacao/resource/ef3bd0b8-b605-474b-9ae5-c97390c197a8')
links <- html_data %>% html_nodes("a")
urls <- links %>% html_attr("href")

#selecionando os links das ufs
ufs <-urls[15:41]

#criando df
vacina<-data.frame()

#download dos dados
fls = basename(ufs)

temp<-tempfile()


for (i in ufs) {
  
  curl_fetch_disk(i, temp)
  
  df <- read_delim(temp, delim = ";")
  
  df <- df %>%
    group_by(estabelecimento_uf,vacina_fabricante_nome,vacina_descricao_dose,
             paciente_idade,paciente_enumSexoBiologico) %>%
    summarise('Count'=n())
  
  print(df$estabelecimento_uf[1])
  
  vacina<-rbind(vacina,df)
  
}

setwd('C:/Users/User/Desktop/SEPLAG/covid')
write_xlsx(vacina,'vacinacao_geral.xlsx')

Sys.time()


