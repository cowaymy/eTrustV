<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
$(document).ready(function(){  
    $("#trBookPage").keydown(function (event) { 
        
        var code = window.event.keyCode;
        
        if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) ||code==110 ||code==190 ||code == 8 || code == 9 || code == 13 || code == 46)
        {
         window.event.returnValue = true;
         return;
        }
        window.event.returnValue = false;
        
   });
        
    CommonCombo.make("singleBranch", "/sales/trBook/selectBranch", "", "${branch}", {
        id: "code",
        name: "name"
    });
    
    
    $("#btnAddSingleSave").hide();
    $("#btnReKey").hide();
});

function fn_Generate(){

	if(checkIsValidRequiredField_Add()){

		$("#trBookPage").prop("readonly", true);
        $("#trBookPage").attr("class", "readonly");
        
		$("#trBookNoStart").prop("readonly", true);
        $("#trBookNoStart").attr("class", "readonly");
        
		$("#trBookNoEnd").prop("readonly", true);
        $("#trBookNoEnd").attr("class", "readonly");
        
	    $("#btnAddSingleSave").show();
	    $("#btnReKey").show();
	}
}


 function checkIsValidRequiredField_Add()
{
    var valid = true;
    var Message = "";

    if ($("#prefix").val() == "")
    {
        valid = false;
        Message += "<spring:message code="sal.alert.msg.selectPrefix" /><br />";
    }

    if ($("#trBookNoStart").val() == "")
    {
        valid = false;
        Message += "<spring:message code="sal.alert.msg.start" /><br />";
    }

    if ($("#trBookPage").val() == "")
    {
        valid = false;
        Message += "<spring:message code="sal.alert.msg.pageOfBook" /><br />";
    }
    else
    {
        if ($("#trBookNoStart").val() != "")
        {
        	        	
            if (isNaN($("#trBookNoStart").val().substring(0,1)))
            {
                valid = false;
                Message += "<spring:message code="sal.alert.msg.notNumber" /><br />";
            }
            else
            {
                var quantity = parseInt($("#trBookPage").val());
                var lNo = "";
                
                lNo = fn_getTRLastNo($("#trBookNoStart").val(), quantity);
                
                if (lNo.length > $("#trBookNoStart").val().length)
                {
                    valid = false;
                    Message += "<spring:message code="sal.alert.msg.exceedLength" /><br />";
                }
                else
                {
                	$("#trBookNoEnd").val( lNo );
                }
            }
        }
    }
    if (!valid)    	
    	 Common.alert("<spring:message code="sal.alert.title.generateEndNumSummary" /> "+DEFAULT_DELIMITER + Message);

    return valid;
}

function fn_getTRLastNo(inputNo, quantity)
{
    var retLastNo = "";

    var firstNoInt = 0;
    var lastNoInt = 0;
    
    firstNoInt = parseInt(inputNo);
    lastNoInt = firstNoInt + (quantity - 1);

    retLastNo = lastNoInt + "";
    
    
    if (inputNo.length > retLastNo.length)
    {
        var lengthToRun = (inputNo.length - retLastNo.length);
        for (var i = 1; i <= lengthToRun; i++)
        {
            retLastNo = "0" + retLastNo;
        }
    }
    return retLastNo;
} 

function fn_ReKey(){
	
	$("#trBookPage").prop("readonly", false);
    $("#trBookPage").attr("class", "");
    $("#trBookPage").val("");
    
    $("#trBookNoStart").prop("readonly", false);
    $("#trBookNoStart").attr("class", "");
    $("#trBookNoStart").val("");
    
    $("#trBookNoEnd").prop("readonly", false);
    $("#trBookNoEnd").attr("class", "");
    $("#trBookNoEnd").val("");
    

    $("#btnAddSingleSave").hide();
    $("#btnReKey").hide();
}

function  addSaveBtn_Click()
{
    if (validRequiredField_Save_Add()){
           doSave_Add(li);
    }
}

function validRequiredField_Save_Add()
{
    var valid = true;
    var Message = "";

    if ($("#singleBranch").val() == "")
    {
        valid = false;
        Message += "<spring:message code="sal.alert.msg.selectBranch" /><br />";
    }
    if ($("#prefix").val() == "")
    {
        valid = false;
        Message += "<spring:message code="sal.alert.msg.selectPrefix" /><br />";
    }
    if ($("#trBookPage").val() == "")
    {
        valid = false;
        Message += "<spring:message code="sal.alert.msg.pageOfBook" /><br />";
    }
    
    if ($("#trBookNoStart").val() == "")
    {
        valid = false;
        Message += "<spring:message code="sal.alert.msg.start" /><br />";
    }
    if ($("#trBookNoEnd").val() == "")
    {
        valid = false;
        Message += "<spring:message code="sal.alert.msg.generateEndNum" /><br />";
    }

    if ($("#trBookNoStart").val() != "" && $("#trBookNoEnd").val() != "")
    {

        $("#trNoFrom").val($("#prefix").val()  + $("#trBookNoStart").val());
        $("#trNoTo").val($("#prefix").val()  + $("#trBookNoEnd").val());
        
        
        
        Common.ajax("GET", "/sales/trBook/selectTrBookDup", $("#saveAddSingleForm").serialize(), function(result) {
            
            console.log("성공.");
            console.log( result);

            if (result.data)
            {
                valid = false;
                Message += "<spring:message code="sal.alert.msg.existTrBook" /><br />";
            }

       }, "", {async: false} );
    }

    if (!valid)       
        Common.alert("<spring:message code="sal.alert.title.addTrBookSummary" /> "+DEFAULT_DELIMITER + Message);
    
    return valid;
}

function fn_save(){
	
	 if (validRequiredField_Save_Add())
     {
		 if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){     
			 
			 $("#prefix").attr("disabled", false);
			 $("#singleBranch").attr("disabled", false);
			 
	        Common.ajax("POST", "/sales/trBook/saveNewTrBook", $("#saveAddSingleForm").serializeJSON(), function(result){
	
	            console.log("성공." + JSON.stringify(result));
	            console.log("data : " + result.data);
	            
	            $("#btnAddSingleSave").hide();
	            $("#btnReKey").hide();
	            
	            $("#trBookAddSinglePop").hide();
	            //fn_selectCancellReqInfoAjax();
	            Common.alert("<spring:message code="sal.alert.title.trBookSaved" />" + DEFAULT_DELIMITER + "<spring:message code="sal.alert.msg.trBookSaved" /> " + result.data );
	          
	        }
	        , function(jqXHR, textStatus, errorThrown){
	            try {
	                console.log("Fail Status : " + jqXHR.status);
	                console.log("code : "        + jqXHR.responseJSON.code);
	                console.log("message : "     + jqXHR.responseJSON.message);
	                console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
	                }
	            catch (e)
	            {
	              console.log(e);
	            }	
	            Common.alert("<spring:message code="sal.alert.title.saveFail" />" + DEFAULT_DELIMITER + "<spring:message code="sal.alert.msg.failTrBookSave" />");
	        });

        }));
     }
	
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.addNewTrBookSingle" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="post" id="saveAddSingleForm" name="saveAddSingleForm">
<input type="hidden" id="trNoTo" name="trNoTo" />
<input type="hidden" id="trNoFrom" name="trNoFrom" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.branch" /></th>
	<td>
		<select class="disabled w100p" disabled="disabled" id="singleBranch" name="branch">
		</select>
	</td>
	<th scope="row"><spring:message code="sal.text.prefixNo" /></th>
	<td>
		<select class="disabled w100p" disabled="disabled" id="prefix" name="prefix">
			<option value="SO"><spring:message code="sal.text.so" /></option>
		</select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.pageOfBook" /></th>
	<td colspan="3"><input type="text" title="" placeholder="" class="" id="trBookPage" name="trBookPage"/><span><spring:message code="sal.text.maximum200" /></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.startingNumber" /></th>
	<td><input type="text" title="" placeholder="" class="" id="trBookNoStart" name="trBookNoStart"/><p class="btn_sky"><a href="#" onclick="javascript:fn_Generate();"><spring:message code="sal.btn.generate" /></a></p></td>
	<th scope="row"><spring:message code="sal.text.endingNumber" /></th>
	<td><input type="text" title="" placeholder="" class="" id="trBookNoEnd" name="trBookNoEnd"/><p class="btn_sky"><a href="#"  onclick="javascript:fn_ReKey();" id="btnReKey"><spring:message code="sal.btn.reKey" /></a></p></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_save();" id="btnAddSingleSave"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</form>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->