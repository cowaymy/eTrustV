<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript" language="javascript">
    
var  gridID;
var  detailGridID;




$(document).ready(function(){
    
    //AUIGrid 그리드를 생성합니다.
    createAUIGrid();
    createDetailAUIGrid();

    AUIGrid.bind(gridID, "cellDoubleClick", function(event) {
        console.log(event.rowIndex);
        fn_selectDetailListAjax( '1');
    });
   
    fn_keyEvent();
    
});

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


function fn_keyEvent(){
    
    $("#SRV_CNTRCT_PAC_CODE").keydown(function(key)  {
            if (key.keyCode == 13) {
            	fn_mainSelectListAjax();
            }
     });
}



function createAUIGrid() {
	
       var keyValueList = [{"code":"1", "value":"ACT"}, {"code":"8", "value":"IACT"}];
       var typeKeyValueList = [{"code":"0", "value":"Starter Package"}, {"code":"1", "value":"Membership Package"}];
        
        var columnLayout = [
                            {dataField : "srvCntrPacId",     headerText  : "" ,editable       : false ,visible : false } ,
                            { dataField : "srvCntrctPacCode", headerText  : "Package Code",    width : 200 ,editable : true},
                            { dataField : "srvCntrctPacDesc", headerText  : "Package Description",width : 200 ,editable       : true},
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
                            
                            { dataField : "srvCntrctPacDur", headerText  : "Package Duration ",  width  : 80 , dataType:"numeric", formatString : "#,##0.00"},
                            { dataField : "pacType", headerText  : "Package Type ",  width  : 150 , editable       : true
                                , labelFunction : function( rowIndex, columnIndex, value, headerText, item) { 
                                    var retStr = "";
                                    for(var i=0,len=typeKeyValueList.length; i<len; i++) {
                                        if(typeKeyValueList[i]["code"] == value) {
                                            retStr = typeKeyValueList[i]["value"];
                                            break;
                                        }
                                    }
                                                return retStr == "" ? value : retStr;
                            }
                          , editRenderer : {
                                type       : "ComboBoxRenderer",
                                list       : typeKeyValueList, //key-value Object 로 구성된 리스트
                                keyField   : "code", // key 에 해당되는 필드명
                                valueField : "value" // value 에 해당되는 필드명
                            }
                          },
                            { dataField : "srvCntrctPacStartDt",headerText  : "Start Date",  width : 150 ,dataType : "date", formatString : "dd/mm/yyyy",
                            	 editRenderer : {
                                     type : "CalendarRenderer",
                                     showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
                                     onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                                     showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
                                 }   
                            },
                            { dataField : "srvCntrctPacEndDt",         headerText  : "End Date",   width : 150,  dataType : "date", formatString : "dd/mm/yyyy",
                            	 editRenderer : {
                                     type : "CalendarRenderer",
                                     showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
                                     onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                                     showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
                                 }   
                            },
                            { dataField : "userName",       headerText  : "Creator",  width  : 150},
                            { dataField : "c1",     headerText  : "Created",  width          :150,    editable       : false ,dataType : "date", formatString : "dd/mm/yyyy"}
                          
       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: true, fixedColumnCount : 1, selectionMode : "singleRow",  showRowNumColumn : true};  
        
        gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout  ,"" ,gridPros);
    }
    
    
    

function createDetailAUIGrid() {
        
        var columnLayout = [
                            { dataField : "", headerText  : "",    width : 50,  editable : true,
                            	renderer : {
                                    type : "IconRenderer",
                                    iconPosition : "aisleCenter",  // 아이콘 위치 
                                    iconTableRef :  { // icon 값 참조할 테이블 레퍼런스
                                        "default" : "${pageContext.request.contextPath}/resources/AUIGrid/images/delete.png" // default
                                    },
                                    onclick : function(rowIndex, columnIndex, value, item) {
                                        fn_delete();
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
                            { dataField : "srvPacItmProductId", headerText  : "Product ID",    width : 100,  editable : false},
                            { dataField : "stkDesc", headerText  : "Product Name",width : 150,  editable: false },
                            { dataField : "code",   headerText  : "Status",  width          : 100,   editable       : false},
                            { dataField : "srvPacItmRental", headerText  : "price ",  width          : 100, editable       : false   ,dataType:"numeric", formatString : "#,##0.00"},
                            { dataField : "srvPacItmSvcFreq",headerText  : "Period",  width          : 100,   editable       : false },
                            { dataField : "srvPacItmRem",         headerText  : "Remark",   width          : 300,     editable       : false  }
       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1,selectionMode : "singleRow",  showRowNumColumn : true};  
        
        detailGridID = GridCommon.createAUIGrid("detail_list_grid_wrap", columnLayout  ,"" ,gridPros);
    }
    
    
    
function fn_gSave(){
	
    var editedRowItems = AUIGrid.getEditedRowItems(gridID); 
    
    if(editedRowItems.length <= 0) {
    	Common.alert("There Are No Update Items.");
    	return ;
    }
    console.log(editedRowItems);
    param = GridCommon.getEditData(gridID); 
   
    
    Common.ajax("POST", "/sales/mPackages/mListUpdate.do", param, function(result) {
       
         // Common.alert(result.message);
          Common.alert("Product Item Saved "+DEFAULT_DELIMITER + "<b>Product item successfully saved.</b>");
          fn_mainSelectListAjax();
          
      }, function(jqXHR, textStatus, errorThrown) {
          console.log("실패하였습니다.");
          console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
          

          console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
          
      });
    
    console.log(param);
	   
}



function fn_New(){

    Common.popupDiv("/sales/mPackages/membershipPackageRNew.do" ,null, null , true , '_NewAddDiv1');
    
    
    
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
}




function  fn_goAdd(){
	 var selectedItems = AUIGrid.getSelectedItems(gridID);
	

	    if(selectedItems.length <= 0 ){
	          Common.alert("No rental membership package selected. ");
	          return ;
	    }
	    
	  console.log("====fn_goAdd=====>");  
	  console.log(selectedItems);
	  
	  var pram ="?packType="+selectedItems[0].item.pacType+"&packID="+selectedItems[0].item.srvCntrctPacId+"&mod=ADD";
	  Common.popupDiv("/sales/mPackages/membershipPackageRPop.do"+pram ,null, null , true , '_AddDiv1');
    
}




function  fn_goSelectAdd(){
    var selectedItems = AUIGrid.getSelectedItems(detailGridID);
     console.log(selectedItems);
     var pram  ="?packItemID="+selectedItems[0].item.srvPacItmId+"&packID="+selectedItems[0].item.srvCntrctPacId+"&mod=EDIT";
     Common.popupDiv("/sales/mPackages/membershipPackageRPop.do"+pram ,null, null , true , '_goSelectAddDiv1');
   
}

//리스트 조회.
function fn_mainSelectListAjax() {        
Common.ajax("GET", "/sales/mPackages/selectList", $("#sForm").serialize(), function(result) {
	       
	    console.log(result);
	    AUIGrid.setGridData(gridID, result);

	    AUIGrid.clearGridData(detailGridID);   
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
	var srvCntrPacId = selectedItems[0].item.srvCntrctPacId;
	
	if(vcd =="" ) vcd =selectedItems[0].item.srvCntrctPacStusId;
	
	Common.ajax("GET", "/sales/mPackages/selectPopDetail", { SRV_CNTRCT_PAC_ID: srvCntrPacId , SRV_PAC_ITM_STUS_ID:vcd }, function(result) {
	         
      console.log(result);
      AUIGrid.setGridData(detailGridID, result);
   });
	 
}






function fn_delete(){
    
	var selectedItems = AUIGrid.getSelectedItems(detailGridID);
	
	var srvPacItmStusId =1; 
	
	if(selectedItems[0].item.srvPacItmStusId  == 1){
		srvPacItmStusId = 8;
	}
	
    var deleteForm ={
			SRV_PAC_ITM_ID : selectedItems[0].item.srvPacItmId ,
			SRV_PAC_ITM_STUS_ID : srvPacItmStusId
   };

  Common.ajax("POST", "/sales/mPackages/deletePackage.do", deleteForm, function(result) {
      
      Common.alert("PRODUCT ITEM DEACTIVATED  "+DEFAULT_DELIMITER + "The product item has been deactivated for this package.  ");
      fn_selectDetailListAjax('1');
	
	  
     }, function(jqXHR, textStatus, errorThrown) {
         Common.alert("실패하였습니다.");
         console.log("실패하였습니다.");
         console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
         console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
         
     }); 
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
<h2>Rental Membership Package List</h2>
<ul class="right_btns">


    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_New()" >New</a></p></li>
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_mainSelectListAjax()"  ><span class="search"></span>Search</a></p></li>
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_Clear()" ><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
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
    <td colspan="3"><select class="multy_select w40p"   multiple="multiple"  id='PAC_TYPE' name ='PAC_TYPE' >
     <option value="0">Starter Package</option>
     <option value="1">Membership  Package</option>
    </select></td>
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
      <div id="list_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->




<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_selectDetailListAjax('1')"  >Active</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_selectDetailListAjax('8')"  >InActive</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_goAdd()">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="detail_list_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
