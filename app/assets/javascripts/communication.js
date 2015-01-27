$(document).ready(function(){
    var Commu=new function(){
        var that=this,chat_bar=$('.chatbar');
        this.ContactList=new function(){
            var selectcontact=$('.contacts');
            selectcontact.mouseover(function(){
                $(this).addClass("active");
            });
            selectcontact.mouseout(function(){
                $(this).removeClass("active");
            });
            selectcontact.click(function(){
                var user=$(this).data('userinfo');
                chat_bar.find('.titlebar .username').html(user['email']).data('user',user);
                chat_bar.find('#recipient_id').val(user['id']);
                chat_bar.show();
                that.MessageLoad(user['id']);
            });
        };
        this.ChatBarAndMessageContainer=new function(){
            this.ScrollDownMessageContainer=function(){
                var seclectmessagecontainer=$('.chat_barAndMessage_container');
                seclectmessagecontainer.scrollTop(seclectmessagecontainer.prop("scrollHeight"));

            };
            this.ContainerHide=new function(){
                chat_bar.find('.titlebar img').click(function(e){
                    e.stopPropagation();
                    chat_bar.hide();
                });
                chat_bar.find('.titlebar').click(function(){
                    chat_bar.find('.ChatContentField').toggle(function(){
                        $(this).animate({height:0},200);
                    },function(){
                        $(this).animate({height:237},200);
                    });
                });
            };
        };
        this.MessageSending=new function(){
            var textboxselector=$('.chatbar .text_input_field');
            textboxselector.keydown(function(e){
                if(textboxselector.val()=='') {
                    if (e.keyCode == 32) {
                        e.preventDefault();
                    }
                }
            });
        };
        this.MessageLoad= function(recipient_id){
            $.ajax({
                url: "messages/message_load",
                data: {recipient_id: recipient_id},
                type: 'get'

            });
        };
        this.AutoMessageLoad=new function(){
            setInterval(function(){
                if($(".chatbar").is(":visible")) {
                    var user = $('.chatbar .titlebar .username').data('user');
                    var recipient_id = user['id'];
                    $.ajax({
                        url: "messages/message_load",
                        data: {recipient_id: recipient_id},
                        type: 'get'

                    });
                }
            },1000)
        };
    };
});

