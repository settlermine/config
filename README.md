Репозиторий с моими конфигами

# Автоконфигурация девконтейнера


Чтобы сконфигурировать любой девконтейнер в devcontainer.json прописываем строку
```json
{
  "postCreateCommand": "bash <(curl -sL https://raw.githubusercontent.com/settlermine/config/main/scripts/configure-devcontainer.sh)"
}
```
Она установит подцепит скрипт и установит neovim с необходимым конфигом

