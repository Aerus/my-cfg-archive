#! /bin/sh
 
GMAIL=$(conkyEmail --servertype=POP --ssl --servername=pop.gmail.com --username=USERNAME@gmail.com --folder=Inbox --password=PASSWORD --connectiontimeout=20)
YANDEX=$(conkyEmail --servertype=POP --servername=pop.yandex.ru --folder=Inbox --username=USERNAME@yandex.ru --password=PASSWORD --connectiontimeout=20)

 
if [ "$GMAIL" = "?" ]; then
    {
    GMAIL=0
    }
else
    {
    GMAIL=$GMAIL
    }
fi
 
if [ "$YANDEX" = "?" ]; then
    {
    YANDEX=0
    }
else
    {
    YANDEX=$YANDEX
    }
fi
 
echo "Gmail: $GMAIL new e-mail(s)"
echo "Yandex: $YANDEX new e-mail(s)"
 
exit 0