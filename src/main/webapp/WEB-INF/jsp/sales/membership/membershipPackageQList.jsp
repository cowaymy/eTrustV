<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.my-right-style {
    text-align:right;
}
.my-left-style {
    text-align:left;
}
</style>
<script type="text/javaScript" language="javascript">
    
var  gridID;
var  detailGridID;
var  filterGridID;

var typeKeyValueList = [];


$(document).ready(function(){

    fn_codeSearch();
    //AUIGrid 그리드를 생성합니다.
    createAUIGrid();
    createDetailAUIGrid();
    createFilterAUIGrid();
   
    fn_keyEvent();
    
    CommonCombo.make("PAC_TYPE", "/common/selectCodeList.do", {groupCode:'366', orderValue:'CODE'}, "", {
        id: "code",
        name: "codeName",
        type: "M"
    });
});

function fn_codeSearch(){
    
    Common.ajax("GET", "/common/selectCodeList.do", {groupCode:'366', orderValue:'CODE'}, function(result) {
        typeKeyValueList = result;
        console.log(typeKeyValueList);
    }, null, {async : false});
}



function fn_keyEvent(){
    
    $("#SRV_CNTRCT_PAC_CODE").keydown(function(key)  {
            if (key.keyCode == 13) {
            	fn_selectListAjax();
            }
     });
}

function numberCheck(event){
    var code = window.event.keyCode;
    
    
    if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) ||code==110 ||code==190 ||code == 8 || code == 9 || code == 13 || code == 46)
    {
     window.event.returnValue = true;
     return;
    }
    window.event.returnValue = false;
    
    return false;
}

function createAUIGrid() {
	
       var keyValueList = [{"code":"1", "value":"ACT"}, {"code":"8", "value":"IACT"}];
       var freeKeyValueList = [{"code":"0", "value":"No"}, {"code":"1", "value":"Yes"}];
       //var typeKeyValueList = [{"code":"0", "value":"Starter Package"}, {"code":"1", "value":"Membership Package"}];
        
        var columnLayout = [
                            {dataField : "srvMemPacId",     headerText  : "Package Id" ,width : 100,  editable       : false  } ,
                            { dataField : "srvMemCode", headerText  : "Package Code",    width : 120 ,editable : true, style:"my-left-style",
								
                                editRenderer : { 
								      type : "InputEditRenderer", 
								      // 에디팅 유효성 검사 
								      validator : function(oldValue, newValue, rowItem) { 
								          var isValid = true; 
								          if(newValue.length > 12) { 
								                isValid  = false; 
								          } 
								          // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움 
								          return { "validate" : isValid, "message"  : "maxLength 12" }; 
								      } 
								} 
                             },
                            { dataField : "srvMemDesc", headerText  : "Package Description",width : 200 ,editable       : true, style:"my-left-style"},
                            { dataField : "code",   headerText  : "Status",  width          : 80,   editable       : true
                            	 , labelFunction : function( rowIndex, columnIndex, value, headerText, item) { 
                                     var retStr = value;
                                     for(var i=0,len=keyValueList.length; i<len; i++) {
                                         if(keyValueList[i]["code"] == value) {
                                             retStr = keyValueList[i]["value"];
                                             break;
                                         }
                                     }
                                                 return retStr;
                             }
                           , editRenderer : {
                                 type       : "DropDownListRenderer",
                                 list       : keyValueList, //key-value Object 로 구성된 리스트
                                 keyField   : "code", // key 에 해당되는 필드명
                                 valueField : "value" // value 에 해당되는 필드명
                             }
                            },
                            
                            { dataField : "srvMemDur", headerText  : "Package Duration ",  width  : 120 , dataType:"numeric", formatString : "#,##0.00"},
                            { dataField : "srvMemLabChrg", headerText  : "Lab chrg ",  width  : 80 , dataType:"numeric", formatString : "#,##0.00" ,editable       : false },
                            { dataField : "pacType", headerText  : "Package Type ",  width  : 150 , editable       : true
                            	 , labelFunction : function( rowIndex, columnIndex, value, headerText, item) { 
                            		 var retStr = value;
                                     for(var i=0,len=typeKeyValueList.length; i<len; i++) {
                                         if(typeKeyValueList[i]["code"] == value) {
                                             retStr = typeKeyValueList[i]["codeName"];
                                             break;
                                         }
                                     }
                                                 return retStr;
                             }
                           , editRenderer : {
                                 type       : "DropDownListRenderer",
                                 list       : typeKeyValueList, //key-value Object 로 구성된 리스트
                                 keyField   : "code", // key 에 해당되는 필드명
                                 valueField : "codeName" // value 에 해당되는 필드명
                             }
                           },
                            { dataField : "freeMemUse", headerText  : "Free Membership ",  width  : 150 , editable       : true
                            	 , labelFunction : function( rowIndex, columnIndex, value, headerText, item) { 
                            		 var retStr = value;
                                     for(var i=0,len=freeKeyValueList.length; i<len; i++) {
                                         if(freeKeyValueList[i]["code"] == value) {
                                             retStr = freeKeyValueList[i]["value"];
                                             break;
                                         }
                                     }
                                                 return retStr;
                             }
                           , editRenderer : {
                                 type       : "DropDownListRenderer",
                                 list       : freeKeyValueList, //key-value Object 로 구성된 리스트
                                 keyField   : "code", // key 에 해당되는 필드명
                                 valueField : "value" // value 에 해당되는 필드명
                             }
                           },
                            { dataField : "srvMemCrtUserId",       headerText  : "Creator",  width  : 80 ,editable       : false },
                            { dataField : "srvMemCrtDt",     headerText  : "Created",  width          :150,    editable       : false ,dataType : "date", formatString : "dd/mm/yyyy"}
                          
       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: true, selectionMode : "singleRow",  showRowNumColumn : true};  
        
        gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout  ,"" ,gridPros);
        

        AUIGrid.bind(gridID, "cellDoubleClick", function(event) {
            console.log(event.rowIndex);
            fn_selectDetailListAjax( '1');
        });
    }
    
    
    

function createDetailAUIGrid() {
        
        var columnLayout = [
                            { dataField : "", headerText  : "",    width : 50,  editable : true,
                            	renderer : {
                                    type : "IconRenderer",
                                    iconPosition : "aisleCenter",  // 아이콘 위치 
                                    /* iconTableRef :  { // icon 값 참조할 테이블 레퍼런스
                                        "ACT" : "${pageContext.request.contextPath}/resources/AUIGrid/images/delete.png" ,// default -- accept-ok.png
                                        "IACT" : "${pageContext.request.contextPath}/resources/AUIGrid/images/accept-ok.png" // default -- accept-ok.png
                                    }, */
                                    onclick : function(rowIndex, columnIndex, value, item) {
                                        fn_delete();
                                    },
                                    iconFunction : function(rowIndex, columnIndex, value, item){
                                    	var delIcon = "${pageContext.request.contextPath}/resources/AUIGrid/images/delete.png";
                                    	var okIcon = "${pageContext.request.contextPath}/resources/AUIGrid/images/accept-ok.png";
                                    	
                                    	if(AUIGrid.getCellValue(detailGridID, rowIndex, "code") == "ACT")
                                    		return delIcon;
                                    	else
                                    		return okIcon;
                                    }
                                }
                            },
                            { dataField : "", headerText  : "",    width : 50,  editable : true,
                            	renderer : {
                                    type : "IconRenderer",
                                    iconPosition : "aisleCenter",  // 아이콘 위치 
                                    iconTableRef :  { // icon 값 참조할 테이블 레퍼런스
                                        "default" : "${pageContext.request.contextPath}/resources/AUIGrid/images/modified_icon.png" // default
                                    },
                                    onclick : function(rowIndex, columnIndex, value, item) {
                                    	fn_goSelectAdd();
                                    }
                                }
                            },
                            { dataField : "stkId", headerText  : "Product ID",    width : 100,  editable : false, visible: false},
                            { dataField : "stkCode", headerText  : "Product code",    width : 100,  editable : false, style:"my-left-style"},
                            { dataField : "stkDesc", headerText  : "Product Name",width : 150,  editable: false, style:"my-left-style" },
                            { dataField : "code",   headerText  : "Status",  width          : 70,   editable       : false},
                            { dataField : "discontinue",   headerText  : "DISCONTINUE",  width          : 100,   editable       : false,
                            	renderer : {            
                                    type : "CheckBoxEditRenderer",
                                    showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                    editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                                    checkValue : "1", // true, false 인 경우가 기본
                                    unCheckValue : "0"
                              } 
                            },
                            { dataField : "c1", headerText  : "price ",  width          : 100, editable       : false   ,dataType:"numeric", formatString : "#,##0.00"},
                            { dataField : "srvMemItmPriod",headerText  : "Period",  width          : 70,   editable       : false },
                            { dataField : "srvMemItmRem",         headerText  : "Remark",   width          : 300,     editable       : false , style:"my-left-style"  }
       ];
        
        var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1,selectionMode : "singleRow",  showRowNumColumn : true};  
        
        detailGridID = GridCommon.createAUIGrid("detail_list_grid_wrap", columnLayout  ,"" ,gridPros);
        
        // 셀 클릭 이벤트 바인딩
        AUIGrid.bind(detailGridID, "cellClick", function(event){
            
            if(event.columnIndex != 0 && event.columnIndex != 1 ){

                $("#srvPacType").val("1");
                $("#matrlNo").val(AUIGrid.getCellValue(detailGridID, event.rowIndex, "stkCode"));
                $("#productName").val(AUIGrid.getCellValue(detailGridID, event.rowIndex, "stkDesc"));
                $("#srvPacId").val(AUIGrid.getCellValue(detailGridID, event.rowIndex, "srvMemPacId"));
                $("#srvItmStkId").val( AUIGrid.getCellValue(detailGridID, event.rowIndex, "stkId"));   
                
                fn_filterListAjax();
                
            }

        });
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
        { dataField : "bomCompntDesc", headerText  : "Filter Name",       width : 250,  editable : false , style :"my-left-style" },
        { dataField : "compntQty", headerText  : "BOM QTY",    width : 100,  editable : false},
        { dataField : "leadTmOffset", headerText  : "BOM Period",    width : 150,  editable: false},
        { dataField : "changePreiod", headerText  : "Change Period",  width : 120,  editable : true}
   ];

    var gridPros = { usePaging : false,  editable: true, selectionMode : "singleRow",  showRowNumColumn : true};  
    
    filterGridID = GridCommon.createAUIGrid("filter_list_grid_wrap", columnLayout  ,"" ,gridPros);
}
    
    
function fn_gSave(){
	
    var editedRowItems = AUIGrid.getEditedRowItems(gridID); 
    
    if(editedRowItems.length <= 0) {
    	Common.alert("There Are No Update Items.");
    	return ;
    }
    console.log(editedRowItems);
    param = GridCommon.getEditData(gridID); 
   
    

    Common.confirm("<spring:message code='sys.common.alert.save'/>",function(){
    	Common.ajax("POST", "/sales/mQPackages/mListUpdate.do", param, function(result) {
    		 // Common.alert(result.message);
            Common.alert("Product Item Saved "+DEFAULT_DELIMITER + "<b>Product item successfully saved.</b>");
            fn_selectListAjax();
            
        }, function(jqXHR, textStatus, errorThrown) {
            console.log("실패하였습니다.");
            console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
            

            console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
            
        });
    });
       
        
    console.log(param);
	   
}

function fn_filterSave(){
    
    var data = GridCommon.getGridData(filterGridID); 
    var idx = AUIGrid.getRowCount(filterGridID); 
    var formData = $("#filterSaveForm").serializeJSON();
    data.formData = formData;
    
    if(idx <= 0) {
        Common.alert("There Are No Save Items.");
        return ;
    }
    console.log(data);
    

    Common.confirm("<spring:message code='sys.common.alert.save'/>",function(){
    	Common.ajax("POST", "/sales/mPackages/saveFilterInfo.do", data, function(result) {
    		// Common.alert(result.message);
            Common.alert("Filter Item Saved "+DEFAULT_DELIMITER + "<b>Filter item successfully saved.</b>");
            fn_filterListAjax();
            
        }, function(jqXHR, textStatus, errorThrown) {
            console.log("실패하였습니다.");
            console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
            

            console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
            
        });
    });
       
         
    
    console.log(data);
       
}


function fn_Clear(){
    $("#SRV_CNTRCT_PAC_CODE").val(""); 
    $("#SRV_CNTRCT_PAC_DESC").val("");
    $("#SRV_CNTRCT_PAC_DUR").val("");
    $("#MBRSH_CRT_USER_ID").val("");
    $("#SRV_CNTRCT_PAC_STUS_ID").val("");
    $("#PAC_TYPE").val("");

    AUIGrid.clearGridData(gridID);   
    AUIGrid.clearGridData(detailGridID);     
    AUIGrid.clearGridData(filterGridID); 
}




function  fn_goAdd(){
	 var selectedItems = AUIGrid.getSelectedItems(gridID);
	

	    if(selectedItems.length <= 0 ){
	          Common.alert("No rental membership package selected. ");
	          return ;
	    }
	    
	  console.log("====fn_goAdd=====>");  
	  console.log(selectedItems);
	  
	  var pram ="?packType="+selectedItems[0].item.pacType+"&packID="+selectedItems[0].item.srvMemPacId+"&mod=ADD";
	  Common.popupDiv("/sales/mQPackages/membershipPackageQPop.do"+pram ,null, null , true , '_AddDiv1');
    
}




function  fn_goSelectAdd(){
    var selectedItems = AUIGrid.getSelectedItems(detailGridID);
     console.log(selectedItems);
     var pram  ="?packItemID="+selectedItems[0].item.stkId+"&packID="+selectedItems[0].item.srvMemPacId+"&mod=EDIT";
     Common.popupDiv("/sales/mQPackages/membershipPackageQPop.do"+pram ,null, null , true , '_goSelectAddDiv1');
   
}



function fn_new(){
    Common.popupDiv("/sales/mQPackages/membershipPackageQNew.do" ,null, null , true , '_NewAddDiv1');
    
}



//리스트 조회.
function fn_selectListAjax() {        
	
	
Common.ajax("GET", "/sales/mQPackages/selectList", $("#sForm").serialize(), function(result) {
	       
	    console.log(result);
	    AUIGrid.setGridData(gridID, result);
	    

	    AUIGrid.clearGridData(detailGridID);   
	    AUIGrid.clearGridData(filterGridID);   
	 });
}



//리스트 조회.
function fn_selectDetailListAjax(statecd) {        
	
	
	var selectedItems = AUIGrid.getSelectedItems(gridID);
	
	if(selectedItems.length <= 0 ){
	      Common.alert("There Are No selected Items.");
	      return ;
	}
	
	console.log(selectedItems[0]);
	
	var  vcd  = statecd;
	var srvMemPacId = selectedItems[0].item.srvMemPacId;
	
	if(vcd =="" ) vcd =selectedItems[0].item.srvMemPacStusId;
	
	Common.ajax("GET", "/sales/mQPackages/selectPopDetail", { SRV_MEM_PAC_ID: srvMemPacId ,SRV_MEM_ITM_STUS_ID:vcd }, function(result) {
	         
      console.log(result);
      AUIGrid.setGridData(detailGridID, result);

      AUIGrid.clearGridData(filterGridID);   
   });
	
    if(selectedItems[0].item.pacType == "0") {
        AUIGrid.showColumnByDataField(detailGridID, "discontinue");
    } else {
        AUIGrid.hideColumnByDataField(detailGridID, "discontinue");
    }
	 
}

//리스트 조회.
function fn_filterListAjax() {        
	Common.ajax("POST", "/sales/mPackages/selectFilterList", $("#filterSaveForm").serializeJSON() , function(result) {
        
        console.log(result);
        AUIGrid.setGridData(filterGridID, result);

     }, function(jqXHR, textStatus, errorThrown) {
         
         console.log("실패하였습니다.");
         console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);

         console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
         
     });
}




function fn_delete(){
    
	var selectedItems = AUIGrid.getSelectedItems(detailGridID);
	
	var srvMemItmStusId =1; 
	console.log(selectedItems[0]);
	if(selectedItems[0].item.srvMemItmStusId  == 1){
		srvMemItmStusId = 8;
	}
	
    
    var deleteForm ={
    		SRV_MEM_PAC_ID : selectedItems[0].item.srvMemPacId ,
    		SRV_MEM_ITM_STUS_ID : srvMemItmStusId,
            SRV_MEM_ITM_STK_ID :  selectedItems[0].item.stkId
   };

//    Common.confirm("<spring:message code='sys.common.alert.delete'/>",function(){
    	Common.ajax("POST", "/sales/mQPackages/deletePackage.do", deleteForm, function(result) {
    		 Common.alert("PRODUCT ITEM DEACTIVATED  "+DEFAULT_DELIMITER + "The product item has been deactivated for this package.  ");
    	      fn_selectDetailListAjax('1');
    	    
    	      
   	     }, function(jqXHR, textStatus, errorThrown) {
   	         console.log("실패하였습니다.");
   	         console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
   	         console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
   	         
   	     }); 
 //   });
      
     
}




</script>


<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Package Maintenance - Outright</h2>
<ul class="right_btns">


    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_new()" >New</a></p></li>
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectListAjax()"  ><span class="search"></span>Search</a></p></li>
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_Clear()" ><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id='filterSaveForm' name='filterSaveForm'>
    <input type="hidden" id="matrlNo" name = "matrlNo">
    <input type="hidden" id="productName" name = "productName">
    <input type="hidden" id="srvPacId" name = "srvPacId">
    <input type="hidden" id="srvItmStkId" name = "srvItmStkId">
    <input type="hidden" id="srvPacType" name = "srvPacType">
</form>
<form action="#" method="post" id='sForm' name='sForm'>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Package Code</th>
	<td><input type="text" title="" placeholder="Package Code" class="w100p"  id='SRV_CNTRCT_PAC_CODE' name='SRV_CNTRCT_PAC_CODE' /></td>
	<th scope="row">Package Description</th>
	<td><input type="text" title="" placeholder="Package Description" class="w100p"  id='SRV_CNTRCT_PAC_DESC' name='SRV_CNTRCT_PAC_DESC' /></td>
	<th scope="row">Package Duration</th>
	<td><input type="text" onkeydown="javascript: numberCheck(this.event);" title="" placeholder="Package Duration(Mth)" class="w100p" id='SRV_CNTRCT_PAC_DUR'  name='SRV_CNTRCT_PAC_DUR'/></td>
</tr>
<tr>
	<th scope="row">Status</th>
	<td>
	<select class="multy_select w100p" multiple="multiple" id='SRV_CNTRCT_PAC_STUS_ID' name='SRV_CNTRCT_PAC_STUS_ID'>
		  <option value="1">Active</option>
          <option value="8">InActive</option>
	</select>
	</td>
	<th scope="row">Package Type</th>
	<td colspan="3">
	<select class="multy_select w40p"   multiple="multiple"  id='PAC_TYPE' name ='PAC_TYPE' >
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->


</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">

    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_gSave()">Save</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="list_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->




<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_selectDetailListAjax('1')"  >Active</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_selectDetailListAjax('8')"  >InActive</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_goAdd()">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="detail_list_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_filterSave()">Save</a></p></li>
</ul>
<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="filter_list_grid_wrap" style="width:100%; height:200px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->


</section><!-- search_result end -->

</section><!-- content end -->
