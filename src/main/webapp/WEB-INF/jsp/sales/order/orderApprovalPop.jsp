<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

	$(function(){
	    $('#btnSaveApproval').click(function() {
	        fn_onClickBtnSaveApproval();
	    });
        $('#txtApprovalBy').keydown(function (event) {  
            if (event.which === 13) {    //enter  
                $('#txtApprovalCode').focus();
                return false;
            }  
        });
        $('#txtApprovalCode').keydown(function (event) {  
            if (event.which === 13) {    //enter
                fn_onClickBtnSaveApproval();
                return false;
            }  
        });
	});
	
	function fn_onClickBtnSaveApproval() {
        $('#lblErrorMsg_Approval').text('');
        
        if(FormUtil.checkReqValue($('#txtApprovalBy'))) {
            $('#lblErrorMsg_Approval').text('Please key in approval by.');
            return;
        }
        if(FormUtil.checkReqValue($('#txtApprovalCode'))) {
            $('#lblErrorMsg_Approval').text('Please key in approval code.');
            return;
        }
        
        var userid = fn_getLoginInfo();
        
        console.log('userid:'+userid);
        
        if(userid == 0) {
            $('#lblErrorMsg_Approval').text('Approval error.');
            return;
        }
        
        var accessRight = fn_getCheckAccessRight(userid, '321');
        
        console.log('accessRight:'+accessRight);
        
        if(!accessRight) {
            $('#lblErrorMsg_Approval').text('Sorry. You have no access rights to approve ex-order.');
            return;
        }
        else {
            $('#orderApprvalCloseBtn').click();
            
            fn_popOrderDetail();
        }
	}

    function fn_getLoginInfo(){
        var result = 0;

        Common.ajax("GET", "/sales/order/selectLoginInfo.do", $("#formApprv").serializeJSON(), function(rsltInfo) {
            if(rsltInfo != null) {
                result = rsltInfo.userid;
            }
            console.log('fn_getLoginInfo result:'+result);
        }, null, {async : false});

        return result;
    }
    
    function fn_getCheckAccessRight(userId, moduleUnitId){
        var result = false;
/*
        Common.ajax("GET", "/sales/order/selectCheckAccessRight.do", {userId : userId, moduleUnitId : moduleUnitId}, function(rsltInfo) {
            if(rsltInfo != null) {
                result = true;
            }
            console.log('fn_getLoginInfo result:'+result);
        }, null, {async : false});
*/
        return true;
    }
    
</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Plese Key In Old Order</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="orderApprvalCloseBtn" href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="formApprv" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Approval By</th>
	<td>
	<input id="txtApprovalBy" name="loginUserName" type="text" title="" placeholder="Approval By" class="w100p" />
	</td>
</tr>
<tr>
	<th scope="row">Approval Code</th>
	<td>
	<input id="txtApprovalCode" name="userPassword" type="password" title="" placeholder="Approval Code" class="w100p" />
	</td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="left_btns mb10">
	<li><p><span id="lblErrorMsg_Approval" class="red_text"></span></p></li>
</ul>

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a id="btnSaveApproval" href="#">Ok</a></p></li>
</ul>

</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>