FROM amoselb/rstudio-m1

RUN R -e "install.packages('tidyverse')" \
    && R -e "install.packages('sf')" \
    && R -e "install.packages('stars')"  \
    && R -e "install.packages('starsExtra')" \
    && R -e "install.packages('ggspatial')" 
