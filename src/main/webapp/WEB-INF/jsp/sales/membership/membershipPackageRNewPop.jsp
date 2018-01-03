<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
    
var  newGridID;
var  filterNewGridID;
var  filterHiddenGridID;


$(document).ready(function(){
    
    createAUIGrid();
    createFilterAUIGrid();
    
    $("#pacType").on("change", function(){
    	
        var $this = $(this);
    	 if( $this.val() == "0"){
    		 $("#OBLIGT_PRIOD").show(); 
    	 }else{
    	     $("#OBLIGT_PRIOD").hide();
    	 }
    	
    });
    
    $("#filterHidden_list_grid_wrap").hide();
    
    if($("#pacType").val()=='0'){
        
    }else{
    }

    fn_selectCodel();
    
/*     OBLIGT_PRIOD
        
    $("#SRV_CNTRCT_PAC_DUR_POP").keydown(function (event) { 
        
        var code = window.event.keyCode;
        
        if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) ||code==110 ||code==190 ||code == 8 || code == 9 || code == 13 || code == 46)
        {
         window.event.returnValue = true;
         return;
        }
        window.event.returnValue = false;
        
   }); */
    
    CommonCombo.make("pacType", "/common/selectCodeList.do", {groupCode:'366', orderValue:'CODE'}, "", {
        id: "code",
        name: "codeName",
        isShowChoose: false
    });
});


function fn_keyDown(){
	 var code = window.event.keyCode;
     
     if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) ||code==110 ||code==190 ||code == 8 || code == 9 || code == 13 || code == 46)
     {
      window.event.returnValue = true;
      return;
     }
     window.event.returnValue = false;
     return false;
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
      
    }
 });
}



//행 추가 이벤트 핸들러
function auiAddRowHandler(event) {}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) {}


function fn_addRow() {
	
    AUIGrid.forceEditingComplete(filterNewGridID, null, false);
    AUIGrid.forceEditingComplete(newGridID, null, false);
    
	if($('select[name="packcode"]').val() ==""){
        Common.alert("Product Item ADD "+DEFAULT_DELIMITER + "<b>Please key select a product item. <br/>");
		return ;
	}
	
	 var item = new Object();
	 
	 item.stockID =$('select[name="packcode"]').val() ;
	 item.stockDesc =$('select[name="packcode"] :selected').text();
	 item.code =1;	 
	 item.discontinue =0;	 

     item.rentalFee =0;
     item.serviceFreq =0;
     item.rowId ="new";
	 
	 
     if( AUIGrid.isUniqueValue (newGridID,"stockID" ,$('select[name="packcode"]').val())){

    	    Common.ajax("GET", "/sales/mPackages/selectStkCode", {stkId: $('select[name="packcode"]').val()}, function(result) {
    	        
    	        console.log(result);
    	        $("#pMatrlNo").val(result);
    	        $("#pSrvPacType").val('0');
    	        $("#pProductName").val($('select[name="packcode"] :selected').text());
    	        $("#pSrvItmStkId").val($('select[name="packcode"]').val());

                fn_filterNewAjax();
    	        
    	     }, function(jqXHR, textStatus, errorThrown) {
    	         
    	         console.log("실패하였습니다.");
    	         console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);

    	         console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
    	         
    	     });
    	 
          AUIGrid.addRow(newGridID, item, "first");
    }else{
        Common.alert("<b>This product item is exist in list. </b>");
        return ;
    }
     
}


function fn_removeRow() {
	var selectedItems = AUIGrid.getSelectedItems(newGridID);
	
    var idx = AUIGrid.getRowCount(filterHiddenGridID);
    var stkId = AUIGrid.getCellValue(newGridID,  selectedItems[0].rowIndex, "stockID" ) ;
    
    AUIGrid.clearGridData(filterNewGridID); 
    
    for (var i = 0; i < idx; i++){
        
        if( stkId == AUIGrid.getCellValue(filterHiddenGridID, i, "srvItmStkId" ) ){
            AUIGrid.removeRow(filterHiddenGridID, i);
        }
    } 

    AUIGrid.removeSoftRows(filterHiddenGridID);
    AUIGrid.removeRow(newGridID, "selectedIndex");
 }

function createAUIGrid() {
    
       var keyValueList = [{"code":"1", "value":"ACT"}, {"code":"8", "value":"IACT"}];
        
        var columnLayout = [
                            {dataField : "rowId", dataType : "string", visible : false},     /* PK , rowid 용 칼럼*/
                            {dataField : "bom",     headerText  : "" ,editable       : false ,visible : false } ,
                            {dataField : "stockID",     headerText  : "ID" ,editable       : false ,visible : true, editable : false } ,
                            { dataField : "stockDesc", headerText  : "Product Name",    width : 200 ,editable : false},
                            { dataField : "code",   headerText  : "Status",  width          : 80,   editable       : true
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
			                }, {
			                    dataField : "discontinue",
			                    headerText : 'DISCONTINUE',
			                    width : 120,
			                    renderer : {            
			                        type : "CheckBoxEditRenderer",
			                        showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
			                        editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
			                        checkValue : "1", // true, false 인 경우가 기본
			                        unCheckValue : "0"
			                  } 
			                },                            
                            { dataField : "rentalFee", headerText  : "Monthly Rental",width : 100 ,editable       : true ,dataType:"numeric", formatString : "#,##0.00",
                            	editRenderer : {
                                    type : "InputEditRenderer",
                                    onlyNumeric : true,
                                    autoThousandSeparator : true, // 천단위 구분자 삽입 여부 (onlyNumeric=true 인 경우 유효)
                                    allowPoint : true // 소수점(.) 입력 가능 설정
                                }},
                            { dataField : "serviceFreq",       headerText  : "Service Frequency",  width  : 150  ,editable       : true ,dataType:"numeric",
                            	editRenderer : {
                                    type : "InputEditRenderer",
                                    onlyNumeric : true,
                                    autoThousandSeparator : true, // 천단위 구분자 삽입 여부 (onlyNumeric=true 인 경우 유효)
                                }
                            },
                            { dataField : "remark",     headerText  : "Remark",  width          :200,    editable       : true}
       ];

        var gridPros = { usePaging : false,  pageRowCount: 20, editable: true, fixedColumnCount : 1,  showRowNumColumn : true, softRemovePolicy : "exceptNew"};  
        
        newGridID = GridCommon.createAUIGrid("new_list_grid_wrap", columnLayout  ,"rowId" ,gridPros);
        
        // 셀 클릭 이벤트 바인딩
        AUIGrid.bind(newGridID, "cellClick", function(event){
        	
            // 버튼 클릭시 cellEditCancel  이벤트 발생 제거. => 편집모드(editable=true)인 경우 해당 input 의 값을 강제적으로 편집 완료로 변경.
           AUIGrid.forceEditingComplete(filterNewGridID, null, false);
           AUIGrid.forceEditingComplete(newGridID, null, false);
           
        	var id = AUIGrid.getCellValue(newGridID, event.rowIndex, "stockID");
        	
            var activeItems = AUIGrid.getItemsByValue(filterHiddenGridID, "srvItmStkId", id);

            AUIGrid.clearGridData(filterNewGridID); 
            AUIGrid.setGridData(filterNewGridID, activeItems);
                

        });
        
        //셀 더블클릭 이벤트
        AUIGrid.bind(newGridID, "cellDoubleClick", function(event) {
            console.log(event.rowIndex);
        });

        // 에디팅 시작 이벤트 바인딩
        AUIGrid.bind(newGridID, "cellEditBegin", auiCellEditignHandler);
        
        // 행 추가 이벤트 바인딩 
        AUIGrid.bind(newGridID, "addRow", auiAddRowHandler);
        
        // 행 삭제 이벤트 바인딩 
        AUIGrid.bind(newGridID, "removeRow", auiRemoveRowHandler);
     
}


function fn_chnPacType() {
	if($("#pacType").val() == "0") {
        AUIGrid.showColumnByDataField(newGridID, "discontinue");
    } else {
        AUIGrid.hideColumnByDataField(newGridID, "discontinue");
        
        var idx = AUIGrid.getRowCount(newGridID); 
        
        for(var i = 0; i < idx; i++){
             AUIGrid.setCellValue(newGridID, i, "discontinue", '0');
         } 
    }	
}

//AUIGrid 메소드
function auiCellEditignHandler(event)
{
	if(event.type == "cellEditBegin")
	{
	    console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
	    //var menuSeq = AUIGrid.getCellValue(myGridID, event.rowIndex, 9);
	    
	    if(event.dataField == "rentalFee")
	    {
	        // 추가된 행 아이템인지 조사하여 추가된 행인 경우만 에디팅 진입 허용
            if(AUIGrid.isAddedById(newGridID, event.item.rowId) && $("#pacType").val()=='1'){  //추가된 Row
	            return true; 
	        } else {
	            return false; // false 반환하면 기본 행위 안함(즉, cellEditBegin 의 기본행위는 에디팅 진입임)
	        }
	    }
	}
}


function createFilterAUIGrid() {
    
    var columnLayout = [
        { dataField : "srvFilterId", headerText  : "",  width : 50,  editable : false, visible : false},
        { dataField : "srvPacType", headerText  : "",  width : 50,  editable : false, visible : false},
        { dataField : "srvPacId", headerText  : "",  width : 50,  editable : false, visible : false},
        { dataField : "srvItmStkId", headerText  : "",  width : 50,  editable : false, visible : false},
        { dataField : "bom", headerText  : "",  width : 50,  editable : false, visible : false},
        { dataField : "productName", headerText  : "Product Name",  width : 150,  editable : false},
        { dataField : "bomCompnt", headerText  : "Filter Code",   width : 150,  editable : false},
        { dataField : "bomCompntDesc", headerText  : "Filter Name",       width : 280,  editable : false , style :"my-left-style" },
        { dataField : "compntQty", headerText  : "BOM QTY",    width : 80,  editable : false},
        { dataField : "leadTmOffset", headerText  : "BOM Period",    width : 110,  editable: false},
        { dataField : "changePreiod", headerText  : "Change Period",  width : 110,  editable : true}
   ];
  
    var gridPros = { usePaging : false,  editable: true,  showRowNumColumn : true};  
    
    filterNewGridID = GridCommon.createAUIGrid("filterNew_list_grid_wrap", columnLayout  ,"" ,gridPros);
    filterHiddenGridID = GridCommon.createAUIGrid("filterHidden_list_grid_wrap", columnLayout  ,"" ,gridPros);
    
    
    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(filterNewGridID, "cellEditBegin", filterNewCellEditignHandler);

    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(filterNewGridID, "cellEditEnd", filterNewCellEditignHandler);
}

//AUIGrid 메소드
function filterNewCellEditignHandler(event)
{
  if(event.type == "cellEditBegin")
  {
      console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
   }
  else if(event.type == "cellEditEnd")
  {
      console.log("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
      
      var filterCode = AUIGrid.getCellValue(filterNewGridID, event.rowIndex, "bomCompnt" );
      var bom = AUIGrid.getCellValue(filterNewGridID, event.rowIndex, "bom" );
      var changePreiod = AUIGrid.getCellValue(filterNewGridID, event.rowIndex, "changePreiod" );
      
      var idx = AUIGrid.getRowCount(filterHiddenGridID);
      for(var i = 0; i < idx ; i++){
    	  
    	  if(filterCode == AUIGrid.getCellValue(filterHiddenGridID, i, "bomCompnt" ) && bom == AUIGrid.getCellValue(filterHiddenGridID, i, "bom" )){
    		  AUIGrid.setCellValue(filterHiddenGridID, i, "changePreiod", changePreiod );
    	  }
      }
  }

}

    
function fn_Save(){
	 // 버튼 클릭시 cellEditCancel  이벤트 발생 제거. => 편집모드(editable=true)인 경우 해당 input 의 값을 강제적으로 편집 완료로 변경.
    AUIGrid.forceEditingComplete(filterNewGridID, null, false);
    AUIGrid.forceEditingComplete(newGridID, null, false);
    
	
	if(! fn_ValidRequiredField_Master() ) return ;
	
	//if(fn_IsExistSVMContractPackCode()) return ;
	
	
    //추가된 행 아이템들(배열)
    var addedRowItems = AUIGrid.getAddedRowItems(newGridID);
        
    //수정된 행 아이템들(배열)
    var editedRowItems = AUIGrid.getEditedRowColumnItems(newGridID); 
       
    //삭제된 행 아이템들(배열)
    var removedRowItems = AUIGrid.getRemovedItems(newGridID);
    
    var filter = AUIGrid.getGridData(filterHiddenGridID); //     GridCommon.getGridData(filterHiddenGridID); 
    
    //서버로 보낼 데이터 작성
    var saveForm = {
       "add" : addedRowItems,
       "update" : editedRowItems,
       "remove" : removedRowItems,
       "all" : filter,
       "formData" : $("#pSaveForm").serializeJSON() ,
       "SRV_CNTRCT_PAC_CODE" : $("#SRV_CNTRCT_PAC_CODE_POP").val()  ,
       "SRV_CNTRCT_PAC_DUR" : $("#SRV_CNTRCT_PAC_DUR_POP").val() ,
       "SRV_CNTRCT_PAC_DESC" :  $("#SRV_CNTRCT_PAC_DESC_POP").val() ,
       "SRV_CNTRCT_PAC_START_DT" :  $("#SRV_CNTRCT_PAC_START_DT_POP").val() ,
       "SRV_CNTRCT_PAC_END_DT" :  $("#SRV_CNTRCT_PAC_END_DT_POP").val(), 
       "OBLIGT_PRIOD" :  $("#OBLIGT_PRIOD").val(), 
       "pacType" :  $("#pacType").val(), 
       "srvPacType" :  $("#pSrvPacType").val() 
    };
    
    Common.ajaxSync("POST", "/sales/mPackages/newRPackageAdd.do", saveForm , function(result) {
        
        console.log(result);
        
        if(result !=""  && null !=result ){
            Common.alert( "New General Code Saved" +DEFAULT_DELIMITER+"<b>New general code successfully saved.</b>"); 

            fn_mainSelectListAjax();
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
   
   if($("#pacType").val() == "0" && $('#OBLIGT_PRIOD').val() ==""){
        valid = false;
        message += "* Please key in the obligt priod.  <br />";
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
  
  if($('#SRV_CNTRCT_PAC_START_DT_POP').val() !="" && $('#SRV_CNTRCT_PAC_END_DT_POP').val() !=""){
	  
	  var st = $("#SRV_CNTRCT_PAC_START_DT_POP").val().replace(/\//g,'');
      var ed = $("#SRV_CNTRCT_PAC_END_DT_POP").val().replace(/\//g,'');
      
      var stDate = st.substring(4,8) +""+ st.substring(2,4) +""+ st.substring(0,2);
      var edDate = ed.substring(4,8) +""+ ed.substring(2,4) +""+ ed.substring(0,2);
                      
      if(stDate > edDate ){	  
	      valid = false;
	      message += "* <spring:message code='commission.alert.dateGreaterCheck'/> <br />";
	  }
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

//리스트 조회.
function fn_filterNewAjax() {        
    Common.ajax("POST", "/sales/mPackages/selectFilterList", $("#pSaveForm").serializeJSON() , function(result) {
        
        console.log(result);
        AUIGrid.appendData(filterHiddenGridID, result);

     }, function(jqXHR, textStatus, errorThrown) {
         
         console.log("실패하였습니다.");
         console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);

         console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
         
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
<form action="#" method="post" id='pSaveForm' name='pSaveForm'>
    <input type="hidden" id="pMatrlNo" name = "matrlNo">
    <input type="hidden" id="pProductName" name = "productName">
    <input type="hidden" id="pSrvPacId" name = "srvPacId">
    <input type="hidden" id="pSrvItmStkId" name = "srvItmStkId">
    <input type="hidden" id="pSrvPacType" name = "srvPacType">
</form>
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
	<td><input type="text" title="" onkeydown="javascript:fn_keyDown(this.event);"    placeholder="Package Duration" id='SRV_CNTRCT_PAC_DUR_POP' name='SRV_CNTRCT_PAC_DUR_POP'   class="w100p" /></td>
</tr>
<tr>
	<th scope="row">Package Description<span class="must">*</span></th>
	<td><input type="text" title="" placeholder="Package Description" id='SRV_CNTRCT_PAC_DESC_POP' name='SRV_CNTRCT_PAC_DESC_POP'  class="" /></td>
	<th scope="row">Package Type </br>/ Obligation Period<span class="must">*</span></th>
    <td>
    <select style="width: 150px" id='pacType' name ='pacType'  onchange="javascript:fn_chnPacType();">
    </select>
    <input type="text" title="" onkeydown="javascript:fn_keyDown(this.event);" placeholder="Obligation Period" id='OBLIGT_PRIOD' name='OBLIGT_PRIOD' style="width: 120px;     margin-left: 4px"  />
    </td>
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
    
    <select class="" style="width: 270px" id='packcode' name ='packcode' >
    </select>
    
    <p class="btn_sky"><a href="#" onclick="javascript:fn_addRow()">Add Details</a></p></td>
</tr>


</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result mt10"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" onclick="javascript:fn_removeRow()">DEL</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="new_list_grid_wrap" style="width:100%; height:200px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="filterNew_list_grid_wrap" style="width:100%; height:180px; margin:0 auto;"></div>
      <div id="filterHidden_list_grid_wrap" style="width:100%; height:210px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_Save()">Save</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->