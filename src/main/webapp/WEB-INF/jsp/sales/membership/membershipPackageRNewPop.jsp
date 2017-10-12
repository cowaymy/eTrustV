<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
    
var  newGridID;


$(document).ready(function(){
    
    createAUIGrid();

    AUIGrid.bind(newGridID, "cellDoubleClick", function(event) {
        console.log(event.rowIndex);
    });
    
    // 행 추가 이벤트 바인딩 
    AUIGrid.bind(newGridID, "addRow", auiAddRowHandler);
    
    // 행 삭제 이벤트 바인딩 
    AUIGrid.bind(newGridID, "removeRow", auiRemoveRowHandler);
    
    fn_selectCodel();
    
    fn_keyEvent();
    
});



function fn_keyEvent(){
    
  //  $("#SRV_CNTRCT_PAC_CODE").keydown(function(key)  {
   //         if (key.keyCode == 13) {
    //            fn_selectListAjax();
   //         }
   //  });
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



//행 추가 이벤트 핸들러
function auiAddRowHandler(event) {}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) {}


function fn_addRow() {
	 
	if($('select[name="packcode"]').val() ==""){
        Common.alert("Product Item ADD "+DEFAULT_DELIMITER + "<b>Please key select a product item. <br/>");
		return ;
	}
	 
	 var item = new Object();
	 
	 item.stockID =$('select[name="packcode"]').val() ;
	 item.stockDesc =$('select[name="packcode"] :selected').text();
	 item.code =1;
	 
	 
     if( AUIGrid.isUniqueValue (newGridID,"stockID" ,$('select[name="packcode"]').val())){
          AUIGrid.addRow(newGridID, item, "first");
    }else{
        Common.alert("<b>This product item is exist in list. </b>");
        return ;
    }
    
     
}


function fn_removeRow() {
 AUIGrid.removeRow(newGridID, "selectedIndex");
}




function createAUIGrid() {
    
       var keyValueList = [{"code":"1", "value":"ACT"}, {"code":"8", "value":"IACT"}];
        
        var columnLayout = [
                            {dataField : "stockID",     headerText  : "ID" ,editable       : false ,visible : true, editable : false } ,
                            { dataField : "stockDesc", headerText  : "Product Name",    width : 200 ,editable : false},
                            { dataField : "code",   headerText  : "Status",  width          : 100,   editable       : true
			                                , labelFunction : function( rowIndex, columnIndex, value, headerText, item) { 
			                                 var retStr = "";
			                                 for(var i=0,len=keyValueList.length; i<len; i++) {
			                                     if(keyValueList[i]["code"] == value) {
			                                         retStr = keyValueList[i]["value"];
			                                         break;
			                                     }
			                                 }
			                                             return retStr == "" ? value : retStr;
			                         }
			                       , editRenderer : {
			                             type       : "ComboBoxRenderer",
			                             list       : keyValueList, //key-value Object 로 구성된 리스트
			                             keyField   : "code", // key 에 해당되는 필드명
			                             valueField : "value" // value 에 해당되는 필드명
			                         }
			                },
                            
                            { dataField : "rentalFee", headerText  : "Monthly Rental",width : 100 ,editable       : true ,dataType:"numeric", formatString : "#,##0.00"},
                            { dataField : "serviceFreq",       headerText  : "Service Frequency",  width  : 150  ,editable       : true ,dataType:"numeric", formatString : "#,##0.00"},
                            { dataField : "remark",     headerText  : "Remark",  width          :300,    editable       : true}
       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: true, fixedColumnCount : 1, selectionMode : "singleRow",  showRowNumColumn : true};  
        
        newGridID = GridCommon.createAUIGrid("new_list_grid_wrap", columnLayout  ,"" ,gridPros);
}
    
    
    
function fn_Save(){
	
	if(! fn_ValidRequiredField_Master() ) return ;
	
	//if(fn_IsExistSVMContractPackCode()) return ;
	
	
    //추가된 행 아이템들(배열)
    var addedRowItems = AUIGrid.getAddedRowItems(newGridID);
        
    //수정된 행 아이템들(배열)
    var editedRowItems = AUIGrid.getEditedRowColumnItems(newGridID); 
       
    //삭제된 행 아이템들(배열)
    var removedRowItems = AUIGrid.getRemovedItems(newGridID);
    
    //서버로 보낼 데이터 작성
    var saveForm = {
       "add" : addedRowItems,
       "update" : editedRowItems,
       "remove" : removedRowItems,
       "SRV_CNTRCT_PAC_CODE" : $("#SRV_CNTRCT_PAC_CODE_POP").val()  ,
       "SRV_CNTRCT_PAC_DUR" : $("#SRV_CNTRCT_PAC_DUR_POP").val() ,
       "SRV_CNTRCT_PAC_DESC" :  $("#SRV_CNTRCT_PAC_DESC_POP").val() ,
       "SRV_CNTRCT_PAC_START_DT" :  $("#SRV_CNTRCT_PAC_START_DT_POP").val() ,
       "SRV_CNTRCT_PAC_END_DT" :  $("#SRV_CNTRCT_PAC_END_DT_POP").val() 
    };
    
    Common.ajaxSync("POST", "/sales/mPackages/newRPackageAdd.do", saveForm , function(result) {
        
        console.log(result);
        
        if(result !=""  && null !=result ){
            Common.alert( "New General Code Saved" +DEFAULT_DELIMITER+"<b>New general code successfully saved.</b>"); 

            $("#_NewAddDiv1").remove();
            return true;
        }else{
            Common.alert( "Failed To Save" +DEFAULT_DELIMITER+"<b>Failed to save.Please try again later.</b>"); 

        	return false;
        }
    });

	
}
    
    
    
function fn_ValidRequiredField_Master(){
	
	var  valid = true;
    var  message = "";
    
    if($('#SRV_CNTRCT_PAC_CODE_POP').val() ==""){
    	  valid = false;
          message += "* Please key in the package code. <br />";
          
    }else{
    	
    	if(fn_IsExistSVMContractPackCode()){
    		valid = false;
            message += "* This package code is existing. <br />";
    	}
    }
    
    
   if($('#SRV_CNTRCT_PAC_DESC_POP').val() ==""){
        valid = false;
        message += "* Please key in the package description.  <br />";
  }
  
   
  if($('#SRV_CNTRCT_PAC_DUR_POP').val() ==""){
       valid = false;
       message += "* Please key in the package duration. <br />";
  }
   

  if($('#SRV_CNTRCT_PAC_START_DT_POP').val() ==""){
       valid = false;
       message += "* Please key in the package start date . <br />";
  }
  

  if($('#SRV_CNTRCT_PAC_END_DT_POP').val() ==""){
       valid = false;
       message += "* Please key in the package end date . <br />";
  }
  var addedRowItems = AUIGrid.getAddedRowItems(newGridID);
  var editedRowItems = AUIGrid.getEditedRowColumnItems(newGridID); 
  var removedRowItems = AUIGrid.getRemovedItems(newGridID);
	
  
  if (addedRowItems.length  ==0 &&  editedRowItems.length ==0 && removedRowItems.length ==0  ){
	  valid = false;
      message += "* You must add at least 1 product item. <br />";
  }
  
  if (!valid)
      Common.alert(" Add Package "+DEFAULT_DELIMITER + message );
  
  return valid;
}



function fn_IsExistSVMContractPackCode(){
	
    Common.ajaxSync("GET", "/sales/mPackages/IsExistSVMPackage", {SRV_CNTRCT_PAC_CODE: $("#SRV_CNTRCT_PAC_CODE_POP").val()  }, function(result) {
        
    	 console.log("============>");
    	console.log(result);
        
        if( result.length > 0 ){
            return true;
            
        }else{
            return false;
        }
    });
   
}
    
</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Add Package</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>Package Information</h2>
</aside><!-- title_line end -->

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
	<th scope="row">Package Code<span class="must">*</span></th>
	<td><input type="text" title="" id='SRV_CNTRCT_PAC_CODE_POP'  name='SRV_CNTRCT_PAC_CODE_POP'  placeholder="Package Code" class="w100p" /></td>
	<th scope="row">Package Duration<span class="must">*</span></th>
	<td><input type="text" title="" placeholder="Package Duration" id='SRV_CNTRCT_PAC_DUR_POP' name='SRV_CNTRCT_PAC_DUR_POP'   class="w100p" /></td>
</tr>
<tr>
	<th scope="row">Package Description<span class="must">*</span></th>
	<td colspan="3"><input type="text" title="" placeholder="Package Description" id='SRV_CNTRCT_PAC_DESC_POP' name='SRV_CNTRCT_PAC_DESC_POP'  class="" /></td>
</tr>

<tr>
    <th scope="row">Start Date  <span class="must">*</span></th>
    <td><input type="text" title="Create start Date"   id="SRV_CNTRCT_PAC_START_DT_POP" name="SRV_CNTRCT_PAC_START_DT_POP" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
    <th scope="row">End Date<span class="must">*</span></th>
    <td><input type="text" title="Create end Date"   id="SRV_CNTRCT_PAC_END_DT_POP" name="SRV_CNTRCT_PAC_END_DT_POP" placeholder="DD/MM/YYYY" class="j_date w100p" /> </td>
</tr>

</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Product Information</h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>

<tr>
    <th scope="row">Product Item<span class="must">*</span></th>
    <td colspan="3">
    
    <select class=""  id='packcode' name ='packcode' >
    </select>
    
    <p class="btn_sky"><a href="#" onclick="javascript:fn_addRow()">Add Details</a></p></td>
</tr>


</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result mt30"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_removeRow()">DEL</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="new_list_grid_wrap" style="width:100%; height:210px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_Save()">Save</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->