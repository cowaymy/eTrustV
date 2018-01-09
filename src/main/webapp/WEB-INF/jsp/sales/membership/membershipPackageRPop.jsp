<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">


var packageInfo={};

$(document).ready(function(){
    $("#discontinue").val("0");

    fn_selectCodel();
    
    CommonCombo.make("pacType", "/common/selectCodeList.do", {groupCode:'366', orderValue:'CODE'}, "", {
        id: "code",
        name: "codeName"
    });
});


function numberCheck(event){
    var code = window.event.keyCode;
    
    
    if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) ||code==110 ||code==190 ||code == 8 || code == 9 || code == 13 || code == 46)
    {
     window.event.returnValue = true;
     return;
    }
    window.event.returnValue = false;
    
    return window.event.returnValue;
}


//PackID=" + packID + "&PackItemID=" + packItemID;
//리스트 조회.
function fn_selectListAjax() {       
	
	var packItemID = '${packItemID}';
	var packID = '${packID}';
	var packType = '${packType}';	 
	
	Common.ajax("GET", "/sales/mPackages/selectPopUpList", {SRV_CNTRCT_PAC_ID: packID, SRV_PAC_ITM_ID:packItemID }, function(result) {
	  
		
	     console.log(result);
	      
	      
	      if (result[0] != null) {
	    	  
	    	  packageInfo = result[0];
	    	    
              
	    	  $('#packcode option[value="' + packageInfo.srvPacItmProductId +'"]').prop('selected', true);
	    	
	    	  $("#srvPacItmRental").val(packageInfo.srvPacItmRental);  
	    	  $("#srvPacItmSvcFreq").val(packageInfo.srvPacItmSvcFreq);  
	    	  $("#remark").val(packageInfo.srvPacItemRemark);
	    	  $("#pacType").val(packageInfo.pacType);
	    	  
	    	  if(packageInfo.discontinue == "1"){
	    		  $("#discontinue").val(packageInfo.discontinue);
	    		  $("#discontinue").attr("checked","checked");
	    	  }
	    	  	    	  
	    	  if($("#pacType").val() != "1"){
                  $("#srvPacItmRental").prop("readonly", true);
                  $("#srvPacItmRental").attr("class", "readonly");
             }
	    	  
	   }else{
	        	$("#pacType").val(packType);
	            
	            if($("#pacType").val() != '1'){
	                $("#srvPacItmRental").prop("readonly", true);
	                $("#srvPacItmRental").attr("class", "readonly");
                    $("#srvPacItmRental").val("0");
	          }
	    }
	      
	      if($("#pacType").val() != "0"){
	        $("#discontinue").attr( "disabled", "disabled" );
	      }

	});
}


function fn_chk(){
	if($("input:checkbox[id='discontinue']").is(":checked")){
		$("#discontinue").val("1");
	}else{
        $("#discontinue").val("0");
	}
}



function fn_IsExistSVMContractPackCode() {       
   //this.txtCode.Text.Trim(), excludePackID)
	Common.ajaxSync("GET", "/sales/mPackages/isExistSVMPackCode", {SRV_PAC_ITM_ID: '${packID}'  }, function(result) {
    
		console.log(result);
		
		if(result !=""  && null !=result ){
			
			return true;
		}else{
			return false;
		}
		
		
    });
}



function fn_save(){
	
	
	if( ! fn_ValidRequiredField_Master()) return ;
	
	var  packItemID = '${packItemID}';
	var  modType  = '${modType}';

	var saveForm ={
              mod :modType,
    		 srvPacItemID : packItemID,
    	     srvContractPacID : '${packID}'  ,  
    	     srvPacItemProductID :   $('select[name="packcode"]').val(),
    	     srvPacItemServiceFreq : $("#srvPacItmSvcFreq").val(),
    	     srvPacItemRental :  $("#srvPacItmRental").val(),
    	     srvPacItemPV :  0,
    	     srvPacItemRemark :  $("#remark").val().trim(),
    	     discontinue :  $("#discontinue").val(),
    	     srvPacItemStatusID : 1

    };

    Common.ajax("POST", "/sales/mPackages/insertPackage.do", saveForm, function(result) {
        
           Common.alert("<spring:message code="sal.alert.title.productItemSaved" /> "+DEFAULT_DELIMITER + "<b><spring:message code="sal.alert.msg.productItemSaved" /></b>");
           fn_DisableField();

           fn_selectDetailListAjax( '1');
       }, function(jqXHR, textStatus, errorThrown) {
    	   
           console.log("실패하였습니다.");
           console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
           
           Common.alert("<spring:message code="sal.alert.title.saveFail" /> "+DEFAULT_DELIMITER + "<b><spring:message code="sal.alert.msg.saveFail" /></b>");

           console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
           
       }); 
	
}




function fn_ValidRequiredField_Master(){
	
	var valid =true;
	var message ="";
	
	
	if($('select[name="packcode"]').val()  ==""){
	
		  valid = false;
	      message += "* <spring:message code="sal.alert.msg.productItemAdd" /> <br />";
	}
	
	if($("#srvPacItmRental").val() ==""){
		 valid = false;
	        message += "* <spring:message code="sal.alert.msg.keyInRentalFee" /> <br />";
	}  
	
    if($("#srvPacItmSvcFreq").val() ==""){
    	  valid = false;
          message += "* <spring:message code="sal.alert.msg.keyInServiceFrequency" /> <br />";
    }  
    
    if("${modType}" ==  "ADD"){
    	var idx = AUIGrid.getRowCount(detailGridID);
        
        for(var i = 0 ; i < idx; i++){
            
            if($("#packcode").val() == AUIGrid.getCellValue(detailGridID, i, "srvPacItmProductId") ){
                valid = false;
                message+="* <spring:message code="sal.alert.msg.alreadyRegisteredContents" />";
                break;
            }
        }
    }
    
    if (!valid)
        Common.alert("<spring:message code="sal.alert.title.addPack" /> "+DEFAULT_DELIMITER + message);

    
    return valid;
}


//리스트 조회.
function fn_selectCodel() {        
Common.ajax("GET", "/sales/mPackages/selectCodel", $("#sForm").serialize(), function(result) {
      console.log(result);
      
      
      if(null !=result ){
    	
    	  var  gList = Array();
    	  
    	  var  cList =Array();
    	  
    	  if (typeof(result.groupCodeList) != 'undefined' && result.groupCodeList !== null) {
              for (var k in result.groupCodeList) {
            	  gList[k] = result.groupCodeList[k].codeName;
              }
          }
    	    
   	     $.each(gList, function(index, value){
   	         $("#packcode").append('<optgroup label="'+value+'"  id="optgroup_'+index+'" >');
   		     
	   		      for(var k in result.codeList ){
	   		    	  if( typeof(result.codeList[k]) != 'undefined' && result.codeList[k].groupcd !== null  ){
	   		    		  
	   		    		  if(result.codeList[k].groupcd  == value ){
	   		    		    // console.log(result.codeList[k]);
	   		    	         $('<option />', {
	   		    	              value : result.codeList[k].codeid ,
	   		    	              text: result.codeList[k].codename 
	   		    	         }).appendTo($("#optgroup_"+index)); 

	                       }
	   		    	  }
	   		      }
	   		      
   		      $("#packcode").append('</optgroup>');
   	    });
   	     
   	    $("optgroup").attr("class" , "optgroup_text");
   	    
   	     fn_selectListAjax();
      }
   });
   
  
}



function fn_DisableField(){
	
    $("#packcode").attr("disabled" ,"disabled");
    $("#srvPacItmRental").attr("disabled" ,"disabled");
    $("#srvPacItmSvcFreq").attr("disabled" ,"disabled");
    $("#remark").attr("disabled" ,"disabled");
    $("#savebt").attr("style" ,"display:none");
}


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.editProductItem" /> </h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
	
	<li><a href="#"><spring:message code="sal.tap.tilte.productInfo" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:190px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.productItem" /><span class="must">*</span></th>
	<td> 
     <c:if test="${modType eq 'EDIT' }">
       <select class="w100p disabled"   disabled ="disabled"  id='packcode' name='packcode'    > </select>
     </c:if>
      <c:if test="${modType eq 'ADD' }">
        <select class="w100p " id='packcode' name='packcode' > </select>
     </c:if>
    </td>    
	<th scope="row"><spring:message code="sal.text.monthlyRental" /> <span class="must">*</span></th>
	<td><input type="text" onkeydown="javascript: numberCheck(this.event);" title="" placeholder="<spring:message code="sal.text.monthlyRental" />" class="w100p" id="srvPacItmRental"  name="srvPacItmRental"/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.serviceFrequency" /> <span class="must">*</span></th>
	<td><input type="text" onkeydown="javascript: numberCheck(this.event);" title="" placeholder="<spring:message code="sal.text.serviceFrequency" />" class=""  id="srvPacItmSvcFreq"  name="srvPacItmSvcFreq" /></td>
	<th scope="row"><spring:message code="sal.text.packType" /> <span class="must">*</span></th>
    <td>    
    <select class="w40p disabled"  id='pacType' name ='pacType'  disabled ="disabled" >
    </select>
    </td> 
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.DISCONTINUE" /><span class="must"></span></th>
	<td colspan="3"><input type="checkbox"  id="discontinue"  name="discontinue" onclick="fn_chk()"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /> </th>
    <td colspan="3"> <textarea cols="20" rows="5" id='remark'  name='remark' placeholder="<spring:message code="sal.text.remark" />" name='remark'></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" id='savebt'   onclick="javascript:fn_save()"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</article><!-- tap_area end -->


</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->