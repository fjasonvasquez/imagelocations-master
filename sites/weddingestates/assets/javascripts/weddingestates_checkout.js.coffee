$(document).ready ->
    $(document).on 'ajax:before', '#new_subscription', (e)->
        $(this).find('[type="submit"]').button('loading');
    
    $(document).on 'ajax:complete', '#new_subscription', (e)->
        $(this).find('[type="submit"]').button('reset');