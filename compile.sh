#! /bin/bash
{ \
    cat src/diary_head.sh; \
    tail +2 src/diary_template.sh; \
    tail +2 src/diary_help.sh; \
    tail +2 src/diary_restore.sh; \
    tail +2 src/diary_add.sh; \
    tail +2 src/diary_open.sh; \
    tail +2 src/diary_config.sh; \
    tail +2 src/diary_stats.sh; \
    tail +2 src/diary_delete.sh; \
} > diary.sh
echo "Compilation is successful"
