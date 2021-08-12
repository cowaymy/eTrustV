<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<script type="text/javaScript">

$(document).ready(function(){
	
	$("#sendSms_AsId").val($("#sms_AsId").val());
	$("#sendSms_AsNo").val($("#sms_AsNo").val());
	//$("#sendSms_MemId").val($("#sms_MemId").val());
	//$("#sendSms_MemCode").val($("#sms_MemCode").val());
	$("#sendSms_PresetMessage").val($("#sms_Message").val());
	$("#sendSms_Message").val($("#sms_Message").val());
	$("#totalchar").html($("#sms_Message").val().length);   
	fn_getSmsCTMemberById();
	
	
});


function  fn_setMessage(){
	
    var smsMag =$("#sendSms_Message").val();
    var rTelNo    =$("#sendSms_CtMobile").val();   
    
    Common.ajax("GET", "/services/as/sendSMS.do",{rTelNo:rTelNo , msg :smsMag} , function(result) {
        console.log("sms.");
        console.log( result);
        
        if(result.isOky =="OK"){
        	   Common.alert("SMS to CT has successfully added into SMS queue list.<br />" ,function (){
        		   $("#_dosmsmDiv").hide(); 
        	   } );
              
        }
    });

	 
}


function fn_sendSMS(){
	
        Common.ajax("GET", "/services/as/sendSMS.do", $("#smsForm").serialize(), function(result) {
            console.log(result );
        });
}



function fn_getSmsCTMemberById(){
    
        Common.ajax("GET", "/services/as/getSmsCTMemberById.do",{MEM_ID: $("#sms_MemId").val()}, function(result) {
        	console.log("fn_getSmsCTMemberById" );
            console.log(result );
            
           $("#sendSms_MemCode").val("("+result.memCode+")" + result.name ); 
           $("#sendSms_CtMobile").val(result.telMobile); 
           
           fn_getMemberByMemberIdCode( $("#sms_MemId").val());
           
        });
}



function fn_getSmsCTMMemberById(_memId){
    
          Common.ajax("GET", "/services/as/getSmsCTMemberById.do",{MEM_ID: _memId}, function(result) {
        	console.log("fn_getSmsCTMMemberById" );
            console.log(result );
            
           $("#sendSms_CtmMemCode").val("("+result.memCode+")" + result.name); 
           $("#sendSms_CtmMobile").val(result.telMobile); 
           
        });
}





function fn_getMemberByMemberIdCode(_memId){
    
        Common.ajax("GET", "/services/as/getMemberByMemberIdCode.do",{MEM_ID: _memId}, function(result) {
        	console.log("fn_getMemberByMemberIdCode" );
            console.log(result );
            fn_getSmsCTMMemberById(result.lvl3UpId);
        });
}






</script>




<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New SMS</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form action="#" method="post" id='psmsForm'>
    <input type="hidden" title="" id="sendSms_AsId" name="sendSms_AsId">

<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	   <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">AS number</th>
	<td colspan="3"><input type="text" title="" placeholder="" class="w100p"  id='sendSms_AsNo' name='sendSms_AsNo'/></td>
</tr>
<tr>
    <th scope="row">CT</th>
    <td ><input type="text" title="" placeholder="" class="w100p"  id='sendSms_MemCode'  name='sendSms_MemCode' /></td>
    
    <th scope="row">Mobile No</th> 
    <td ><input type="text" title="" placeholder="" class="w100p"   id='sendSms_CtMobile'  name='sendSms_CtMobile'/></td>
    
</tr>

<tr>
    <th scope="row">CTM</th>
    <td ><input type="text" title="" placeholder="" class="w100p"   id='sendSms_CtmMemCode'  name='sendSms_CtmMemCode'  /></td>
    
    <th scope="row">Mobile No</th>
    <td ><input type="text" title="" placeholder="" class="w100p" id='sendSms_CtmMobile'  name='sendSms_CtmMobile' /></td>
</tr>
<tr>
	<th scope="row">Preset Message </th>
	<td  colspan="3" ><textarea cols="20" rows="5"   id='sendSms_PresetMessage'  name='sendSms_PresetMessage'></textarea></td>
</tr>

<tr>
    <th scope="row">Message To Send</th>
    <td  colspan="3" ><textarea cols="20" rows="5"  id='sendSms_Message'  name='sendSms_Message'></textarea></td>
</tr>
<tr>
	<th scope="row">Total Characters</th>
	<td colspan="3" ><span id='totalchar'></span></td>
</tr>
</tbody>
</table><!-- table end -->

</form>

<ul class="center_btns mt20">
	<li><p class="btn_blue2 big"><a href="#"  onclick="javascript:fn_setMessage()">Send SMS</a></p></li>
</ul>

</section><!-- pop_body end -->
</div><!-- popup_wrap end -->