<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">



	function fn_doSave(){
	    
	    if ( ! validRequiredField_AddFilter()) {
	       return ;
	    }else {
	            
            fn_addSvrfilterSetting();
	    }
	    
	   
/* 	   fn_setSaveFormData(); */
	}

    
    var lastChangeDate ="";
    var  remark = "";           
    
    function fn_addSvrfilterSetting(){
           var cnt =0;
           var filterCode =  $("#ddlFilterCode option:selected").val();
           
           var  filterCntForm ={
            "salesOrdId": salesOrdId ,
            "filterCode" : filterCode
            }
            
            
           Common.ajax("GET", "/services/bs/addSrvFilterID.do", filterCntForm, function(result) {
                console.log("fn_asAddRemark.");
                console.log(result);
                
                cnt = parseInt(result[0].cnt,10);

	            if(cnt > 0){
	/*                 return true; */
	/*                 addFilterMsg.Text = "* This filter is existing."; */
	                   Common.alert("This filter is existing.");
	/*                 this.LoadOrderActiveFilter(); */
	                
	                return;
	                
	            }else {
	/*                 return false; */
	                  
	                  
	                  if(FormUtil.checkReqValue($("#dpPrevServiceDate"))){
	                      lastChangeDate = $("#dpPrevServiceDate").val();
	                  }else {
	                      lastChangeDate = ("01/01/1900");
	                  }
	                  
	
	                  if($("#txtRemark").val()!= ""){
	                      remark = $("#txtRemark").val();
	                  }
	                        
	                  fn_doSaveFilterInfo_Add();      
	/*                         if (this.doSaveFilterInfo_Add(OrderID, ProductID, StockID, LastChangeDate, Remark, li))
	                        {
	                            Common.alert(("<b>The filter successfully added.</b>", 380, 160, "Filter Successfully Added", "callBackFn", null);
	                            this.LoadOrderInactiveFilter();
	                            this.LoadOrderActiveFilter();
	                            RadWindow_AddFilter.VisibleOnPageLoad = false;
	                        }
	                        else
	                        {
	                            Common.alert(("<b>Failed to add this filter. Please try again later.</b>", 380, 160, "Filter Fail To Add", "callBackFn", null);
	                        } */
	            
	            
	            }
            
            });
    }
    
    
    
    function fn_doSaveFilterInfo_Add() {
         
         var  filterSaveForm ={
            "salesOrdId": salesOrdId ,
            "productID" : $("#stkId").val(),
            "filterCode" : $("#ddlFilterCode option:selected").val(),
            "lastChangeDate" : lastChangeDate,
            "remark" : remark
            }
         
         
          Common.ajax("POST", "/services/bs/doSaveFilterInfo.do", filterSaveForm, function(result) {
               console.log("fn_doSaveFilterInfo_Add.");
               console.log(result);
               
               if(result.code = "00"){
                    $("#popClose").click();
                    fn_getInActivefilterInfo();
                    fn_getActivefilterInfo();
                     Common.alert("<b>The filter successfully added.</b>",fn_close);
               }else{
                    Common.alert("<b>Failed to add this filter. Please try again later.</b>");
               }
           });
    }
    
    
    function fn_close() {
        $("#popClose").click();
    }
    
    
/*     function fn_parentReload() {
        
        fn_getAddFilter(); //parent Method (Reload)
    } */
    
    
    function validRequiredField_AddFilter(){
    
        
        var rtnMsg ="";
	    var valid =true;
        
        
	    if($("#ddlFilterCode option:selected").val() ==""){
	        Common.alert("Some required FilterCode fields are empty.<br/>");
	        return ;
	    }
    
    
        if(FormUtil.checkReqValue($("#dpPrevServiceDate"))){
            rtnMsg  +="* Some required ServiceDate fields are empty.<br/>" ;
            valid =false; 
        }
        
    
/*         if(FormUtil.checkReqValue($("#ddlFilterCode").val())){
 	        rtnMsg  +="* Some required FilterCode fields are empty.<br/>" ;
	        valid =false; 
	    }
	    
	    if(FormUtil.checkReqValue($("dpPrevServiceDate"))){
	        rtnMsg  +="* Some required ServiceDate fields are empty.<br/>" ;
            valid =false; 
	    } */


	    if( valid ==false ){
	        Common.alert("Required Fields Missing" +DEFAULT_DELIMITER +rtnMsg );
	    }
    

         return valid;
    }
    
    
    
    $(document).ready(function() {
                    
    });
    
    

        
        
        
function fn_asAddFilter(){
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    var ordList ={
             "ordList":selectedItems,
             "BRID" : "CSD001"
    }
    
    
    
    Common.ajax("GET", "/services/bs/addHsFilter.do", $("#addRemarkForm").serialize(), function(result) {
        console.log("fn_asAddRemark.");
        console.log(result);
        
        if(result.code =="00"){
            Common.alert("* Remark successfully saved.");
            fn_getCallLog();
            $("#_addASRemarkPopDiv").remove();
        }
    });
}
</script>


<div id="popup_filterAddwrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>ADD FILTER</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="popClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="post"  id='addFilterForm'  name='addFilterForm' >
	<input type="hidden" name="salesOrdId"  id="salesOrdId" value="${_salesOrdId}"/>  
	<input type="hidden" name="stkId"  id="stkId" value="${_stkId}"/>  

<section class="tap_wrap"><!-- tap_wrap start -->

<article class="tap_area"><!-- tap_area start -->


<table class="type1"><!-- table start -->

<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <td colspan="2"><span class="must" id="txtResult"><!-- *Some required fields are empty. --></span></td>
</tr>
<tr>
    <th scope="row">Filter Code</th>
    <td>
	    <select class="w100p"  id ="ddlFilterCode" name = "ddlFilterCode"  onchange="" style="height: 26px; width: 407px" >
	        <c:forEach var="list" items="${hSAddFilterSetInfo}" varStatus="status">
                 <option value="${list.codeId}">${list.codeName } </option>
            </c:forEach>
	    </select>
    </td>
</tr>
<tr>
    <th scope="row">Previous Service Date</th>
    <td>
        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpPrevServiceDate"  name="dpPrevServiceDate" style="height: 26px; "/>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td>
        <textarea  id='txtRemark' name='txtRemark'   rows='5' placeholder=""  class="w100p" style="width: 407px; "></textarea>
    </td>
</tr>

</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#"  onclick="fn_doSave()">Save</a></p></li>
</ul>

</article><!-- tap_area end -->


</section><!-- tap_wrap end -->

</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
