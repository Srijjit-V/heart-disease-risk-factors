rm(list = ls())
graphics.off()

library(tidyverse)
library(readr)
library(scales)

# load the dataset (it uses semicolons)
data <- read_delim("cardiovascular_diseases_dv3.csv", delim = ";")

# colors: same salmon “pink” from my other chart + a soft grey
pink_no <- "salmon"
grey_yes <- "gray40"

# make the labels readable
data_clean <- data %>%
  mutate(
    heart_disease = factor(CARDIO_DISEASE, levels = c(0, 1),
                           labels = c("No Heart Disease", "Has Heart Disease")),
    smoke_status = factor(SMOKE, levels = c(0, 1),
                          labels = c("No Smoke", "Smoke")),
    alcohol_status = factor(ALCOHOL, levels = c(0, 1),
                            labels = c("No Alcohol", "Alcohol"))
  )

# ---- smoking pies ----
smoke_pie_data <- data_clean %>%
  count(heart_disease, smoke_status) %>%
  group_by(heart_disease) %>%
  mutate(
    pct = n / sum(n),
    label = percent(pct, accuracy = 1)
  ) %>%
  ungroup()

g_smoke_pie <- ggplot(smoke_pie_data, aes(x = "", y = pct, fill = smoke_status)) +
  geom_col(color = "white", width = 1) +
  coord_polar(theta = "y") +
  facet_wrap(~ heart_disease) +
  scale_fill_manual(values = c("No Smoke" = pink_no, "Smoke" = grey_yes)) +
  geom_text(
    aes(label = label),
    position = position_stack(vjust = 0.5),
    size = 4.5,
    color = "white",
    fontface = "bold"
  ) +
  labs(title = "How does smoking affect heart disease?", x = NULL, y = NULL, fill = NULL) +
  theme_void(base_size = 16) +
  theme(
    plot.title = element_text(size = 17.5, face = "bold", hjust = 0.5, margin = margin(b = 10)),
    strip.text = element_text(size = 12.5, face = "bold"),
    legend.position = "bottom",
    plot.margin = margin(5, 5, 5, 5)
  )

g_smoke_pie
ggsave(
  "pie_smoke_heart_disease_salmon_gray.png",
  plot = g_smoke_pie,
  width = 8,
  height = 4.6,
  dpi = 300,
  bg = "transparent"
)

# ---- alcohol pies ----
alcohol_pie_data <- data_clean %>%
  count(heart_disease, alcohol_status) %>%
  group_by(heart_disease) %>%
  mutate(
    pct = n / sum(n),
    label = percent(pct, accuracy = 1)
  ) %>%
  ungroup()

g_alcohol_pie <- ggplot(alcohol_pie_data, aes(x = "", y = pct, fill = alcohol_status)) +
  geom_col(color = "white", width = 1) +
  coord_polar(theta = "y") +
  facet_wrap(~ heart_disease) +
  scale_fill_manual(values = c("No Alcohol" = pink_no, "Alcohol" = grey_yes)) +
  geom_text(
    aes(label = label),
    position = position_stack(vjust = 0.5),
    size = 4.0,  # a little smaller so it doesn’t crowd
    color = "white",
    fontface = "bold"
  ) +
  labs(title = "How does alcohol affect heart disease?", x = NULL, y = NULL, fill = NULL) +
  theme_void(base_size = 16) +
  theme(
    plot.title = element_text(size = 17.5, face = "bold", hjust = 0.5, margin = margin(b = 10)),
    strip.text = element_text(size = 12.5, face = "bold"),
    legend.position = "bottom",
    plot.margin = margin(5, 5, 5, 5)
  )

g_alcohol_pie
ggsave(
  "pie_alcohol_heart_disease_salmon_gray.png",
  plot = g_alcohol_pie,
  width = 8,
  height = 4.6,
  dpi = 300,
  bg = "transparent"
)