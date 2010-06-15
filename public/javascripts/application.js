var service_id = 0;

function show_detail(in_service_id)
{
    service_id = in_service_id;
    $("#ajaxDialog").dialog("open");
}

$(document).ready(function(){
    var doOk = function() {
        $("#ajaxDialog").dialog("close");
    }
    var dialogOpts = {
        title: "Service details",
        modal: true,
        buttons: {
            "OK": doOk
        },
        autoOpen: false,
        open: function() {
            $("#ajaxDialog").load("/services/"+service_id);
        }
    };
    $("#ajaxDialog").dialog(dialogOpts);
});