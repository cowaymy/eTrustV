<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

var   inHouseRGridID;

function fn_selInhouseList(){
        Common.ajax("GET", "/services/inhouse/selInhouseList.do", $("#inHoForm").serialize(), function(result) {
            console.log(result );
            AUIGrid.setGridData(inHouseRGridID, result);
        
        });
}



$(document).ready(function() {
    createAUIGrid() ;
    doGetCombo('/services/as/getBrnchId', '', '','branchDSC', 'S' , '');           

  
});

function createAUIGrid() {
    
    var columnLayout = [
                        
                        {
                            headerText : "Open IHR Service",
                            children : [ 
                                  
                                        {dataField : "salesOrdNo",     headerText  : "Order No" ,width  : 100 ,  editable       : false  } ,
                                        {dataField : "custName",      headerText  : "Customer" ,width  : 120 ,  editable       : false  } ,
                                        {dataField : "asNo",             headerText  : " Open IHR Service No",  width  : 130 , editable       : false},
                                        {dataField : "memCode",       headerText  : " Open CT Code",  width  : 120   , editable       : false},
                                        {dataField : "stkCode",         headerText  : "Customer Product ",  width  : 120,  editable       : false},
                                        {dataField : "serialNo",          headerText  : "Customer Serial No",  width  : 120,  editable       : false},
                                        {dataField : "inHuseRepairProductCode",             headerText  : "Loan Unit Product ",  width  : 120,  editable       : false},
                                        {dataField : "inHuseRepairSerialNo",             headerText  : "Loan Unit Serial No ",  width  : 120,  editable       : false}
                            ]
                        },
                        {
                            headerText : "IHR Service",
                            children : [ 
                                        {dataField :  "inAsNo",     headerText  : "IHR Service No" ,width  : 100 ,  editable       : false  } ,
                                        {dataField :  "inMemCode",     headerText  : "RCT Code" ,width  : 100 ,  editable       : false  } ,

                                        { dataField : "asAppntDt", headerText  : "IHR Promised Date",  width  : 150   ,dataType : "date", formatString : "dd/mm/yyyy"  , editable       : false},
                                        { dataField : "inAsCrtDt",    headerText  : "IHR Registration Date",  width  : 150 ,  dataType : "date", formatString : "dd/mm/yyyy"  ,editable       : false},
                                        { dataField : "inAsComDt", headerText  : " IHR Complete Date",  width  : 150    ,dataType : "date", formatString : "dd/mm/yyyy"  , editable       : false},
                                        {dataField :  "inAsStus", headerText  : "IHR Status",  width  : 120 , editable    : false}
                            ]
                        },
                        {
                            headerText : "Close IHR Service",
                            children : [ 
                                        {dataField : "onAsNo",     headerText  : "Close IHR Service No." ,width  : 100 ,  editable       : false  } ,
                                        {dataField : "onMemCode",     headerText  : "Close CT Code" ,width  : 100 ,  editable       : false  } ,
                                        {dataField :  "onAsStus", headerText  : "Close IHR Status",  width  : 120 , editable    : false},
                                        { dataField : "onComDt",    headerText  : "Close IHR Complete Date",  width  : 150  , dataType : "date", formatString : "dd/mm/yyyy", editable       : false}
                            ]
                        }
   ];   
   
    
  var gridPros = { usePaging : true,     
            headerHeight : 50,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
            showRowNumColumn : true,
            selectionMode       : "singleRow",
            editable :  false

    };  
    inHouseRGridID= GridCommon.createAUIGrid("grid_wrap_inHouseList", columnLayout  ,"" ,gridPros);
}


function fn_viewInHouseResultPop(){
    
    var selectedItems = AUIGrid.getSelectedItems(inHouseRGridID);
    
    if(selectedItems.length <= 0) {
            Common.alert("<b>No Item selected.</b>");
         return ;
    }
    
    if(selectedItems[0].item.inAsResultNo ==""){
    	  Common.alert("<b>No in-house repiar Item selected.</b>");
          return ;
    }
    

    var pram ="&ORD_ID="+selectedItems[0].item.salesOrdId
                   + "&ORD_NO="+selectedItems[0].item.salesOrdNo
                   +"&AS_NO="+selectedItems[0].item.asNo
                   +"&AS_ID="+selectedItems[0].item.asId
                   +"&AS_RESULT_NO="+selectedItems[0].item.inAsResultNo
                   +"&AS_RESULT_ID="+selectedItems[0].item.inAsResultId;
    
    Common.popupDiv("/services/inhouse/inHouseAsResultEditBasicPop.do?mode=view"+pram  ,null, null , true , '_viewResultDiv');

}





function fn_asInhouseAddOrderPop(){
    
	var selectedItems = AUIGrid.getSelectedItems(inHouseRGridID);
	    
    if(selectedItems.length <= 0) {
            Common.alert("<b>No Item selected.</b>");
         return ;
    }
    console.log(selectedItems);
    
    var pram = "?salesOrderId="+selectedItems[0].item.salesOrdId+"&ordNo="+selectedItems[0].item.salesOrdNo+"&AS_ID="+selectedItems[0].item.asId+"&asResultId="+selectedItems[0].item.inAsResultId;
    
    Common.popupDiv("/services/as/resultASReceiveEntryPop.do"+pram  ,null, null , true , '_resultNewEntryPopDiv1');
    
    
    //Common.popupDiv("/services/as/resultASReceiveEntryPop.do?salesOrderId="+salesOrdId+"&ordNo="+salesOrdNo+"&asResultId="+asResultId ,null, null , true , '_resultNewEntryPopDiv1');
}






function fn_editResultPop(){
var selectedItems = AUIGrid.getSelectedItems(inHouseRGridID);
    
    if(selectedItems.length <= 0) {
            Common.alert("<b>No Item selected.</b>");
         return ;
    }
    
    if(selectedItems[0].item.inAsResultNo ==""){
          Common.alert("<b>No in-house repiar Item selected.</b>");
          return ;
    }
    
  var stae =  selectedItems[0].item.inAsStus ;
  if(stae  !="ACT"){
      Common.alert("</br> Result entry is disallowed.</b>");
      return ;
  }
  
    

    var pram ="&ORD_ID="+selectedItems[0].item.salesOrdId
                   + "&ORD_NO="+selectedItems[0].item.salesOrdNo
                   +"&AS_NO="+selectedItems[0].item.asNo
                   +"&AS_ID="+selectedItems[0].item.asId
                   +"&AS_RESULT_NO="+selectedItems[0].item.inAsResultNo
                   +"&AS_RESULT_ID="+selectedItems[0].item.inAsResultId;
    
    
    
    Common.popupDiv("/services/inhouse/inHouseAsResultEditBasicPop.do?mode=edit"+pram  ,null, null , true , '_editResultDiv');
}



function fn_addRepairPop(){
    
    var selectedItems = AUIGrid.getSelectedItems(inHouseRGridID);
    if(selectedItems.length <= 0) {
            Common.alert("<b>No Item selected.</b>");
         return ;
    }
    

    var stae =  selectedItems[0].item.inAsStus ;
   
    if(stae  =="COM"  ){
        Common.alert("</br> Result entry is disallowed.</b>");
        return ;
    }
    
    var pram ="&ORD_ID="+selectedItems[0].item.salesOrdId
                   + "&ORD_NO="+selectedItems[0].item.salesOrdNo
                   +"&AS_NO="+selectedItems[0].item.asNo
                   +"&AS_ID="+selectedItems[0].item.asId
                   +"&AS_RESULT_NO="+selectedItems[0].item.inAsResultNo
                   +"&AS_RESULT_ID="+selectedItems[0].item.inAsResultId;
    
    Common.popupDiv("/services/inhouse/inhouseDPop.do?mode=NEW"+pram ,null, null , true , '_addResultDiv');
    
}


function fn_addSave(){
    

    //수정된 행 아이템들(배열)
    var editedRowItems = AUIGrid.getEditedRowItems (inHouseRGridID); 

    console.log(editedRowItems);
    if(editedRowItems.length <= 0) {
            Common.alert("<b>No Item change.</b>");
         return ;
     }
    var  updateForm ={
            "update" : editedRowItems
    }
    
    
    Common.ajax("POST", "/services/inhouse/mListUpdate.do",updateForm , function(result) {
        console.log( result);
        
        if(result != null ){
           // fn_setResultData(result);
        }
    });
}


$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = -1;
        }

        $("#repState").val(""); 
    });
};

</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>In House Repair Progress Display</h2>
<ul class="right_btns">



<!-- 


<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">

    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_viewInHouseResultPop()">View Result</a></p></li>
</c:if>    
<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_editResultPop()">Edit Result</a></p></li>
</c:if>
<c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">    
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_addRepairPop()">Add Repair</a></p></li>
</c:if>
<c:if test="${PAGE_AUTH.funcView == 'Y'}">    
    <li><p class="btn_blue"><a href="#" onClick="javascript:fn_selInhouseList()"><span class="search"></span>Search</a></p></li>
</c:if>    
 -->
  <!--  <li><p class="btn_blue"><a href="#" onclick="javascript:fn_asInhouseAddOrderPop()">IHR ADD AS Order</a></p></li> -->


    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_viewInHouseResultPop()">View Result</a></p></li>

    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_editResultPop()">Edit Result</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_addRepairPop()">Add Repair</a></p></li>
    <li><p class="btn_blue"><a href="#" onClick="javascript:fn_selInhouseList()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#inHoForm').clearForm();" ><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="inHoForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>


<tr>
    <th scope="row">Open IHR Service No </th>
    <td>
         <input type="text" title="" placeholder="Open IHR Service No" class="w100p" id="openServiceNo" name="openServiceNo"/>
    </td>
    <th scope="row"> Open CT Code </th>
    <td>
          <input type="text" title="" placeholder="Open CT" class="w100p" id="openCt" name="openCt"/>
    </td>
    <th scope="row">Customer Product</th>
     <td>
        <input type="text" title="" placeholder="Customer Product" class="w100p" id="custProduct" name="custProduct"/>
    </td>
      <th scope="row">Sales Order Number </th>
     <td>
        <input type="text" title="" placeholder="Sales Order Number" class="w100p" id="ordNo" name="ordNo"/>
    </td>
</tr>



<tr>
    <th scope="row">IHR Service No</th>
    <td>
         <input type="text" title="" placeholder="IHR Service No" class="w100p" id="ihrServiceNo" name="ihrServiceNo"/>
    </td>
    <th scope="row"> RCT Code </th>
    <td>
          <input type="text" title="" placeholder="RCT Code" class="w100p" id="rctCode" name="rctCode"/>
    </td>
    <th scope="row">Loan Unit Product</th>
     <td>
        <input type="text" title="" placeholder="Loan Unit Product" class="w100p" id="loanProduct" name="loanProduct"/>
    </td>
      <th scope="row">Customer </th>
     <td>
        <input type="text" title="" placeholder="Customer" class="w100p" id="custId" name="custId"/>
    </td>
</tr>

<tr>
    <th scope="row">Close IHR Service No</th>
    <td>
         <input type="text" title="" placeholder="Close IHR Service No" class="w100p" id="closeServiceNo" name="closeServiceNo"/>
    </td>
    <th scope="row"> Close CT Code </th>
    <td>
          <input type="text" title="" placeholder="Close CT Code" class="w100p" id="closeCtCode" name="closeCtCode"/>
    </td>
    <th scope="row">DSC Code</th>
     <td>
            <select class="w100p" id="branchDSC" name="branchDSC" >
    </td>
      <th scope="row">IHR Promised Date </th>
     <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="promisedDate"  name="promisedDate"/> </td>
</tr>


<tr>
    <th scope="row">Customer Serial Number</th>
    <td>
         <input type="text" title="" placeholder="Customer Serial Number" class="w100p" id="custSerialNo" name="custSerialNo"/>
    </td>
    <th scope="row"> Loan Unit Serial Number </th>
    <td>
          <input type="text" title="" placeholder="Loan Unit Serial Number" class="w100p" id="loanSerialNo" name="loanSerialNo"/>
    </td>
    <th scope="row">IHR Status</th>
     <td>            
            <select class="w100p" id="ihrStatus" name="ihrStatus" >
             <option value=""  selected>Choose One</option>
            <option value="1" >Active</option>
            <option value="4">Completed</option>
            <option value="21">Fail</option>
            <option value="10">Cancelled</option>
            </select>
    </td>
      <th scope="row">Close IHR Status</th>
    
        <td> 
        <select class="w100p" id="closeStatus" name="closeStatus" >           
            <option value="" selected> Choose One</option>
            <option value="1" >Active</option>
            <option value="4">Completed</option>
            <option value="21">Fail</option>
            <option value="10">Cancelled</option>
    </select> </td>
</tr>





</tbody>
</table><!-- table end -->
<%-- 
 <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
          
    </ul>
   
    <ul class="btns">
        <!--<li><p class="link_btn type2"><a href="#" onclick="javascript:fn_newASPop()">New AS Application</a></p></li> -->
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->
 --%>
<ul class="right_btns">
    <!-- <li><p class="btn_grid"><a href="#" onClick="fn_excelDown()">EXCEL DW</a></p></li> -->
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_inHouseList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->
</form>


</section><!-- search_table end -->
</section><!-- content end -->
