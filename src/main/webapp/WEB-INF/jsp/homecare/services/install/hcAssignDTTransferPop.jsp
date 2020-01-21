<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">


var assignCtListGridID;
var assignCOrdtListGridID;
var serialList = [];
var frmSerialList = [];
var v_ctCode = "", v_stkCode = "";
var v_frmCtCode = "", v_frmStkCode = "";

$(document).ready(function() {

    createAssignCtListAUIGrid();
    createAssignCtOrderListAUIGrid();

    fn_asaAssignCtList();
    fn_asaAssignCtOderList();


    AUIGrid.bind(assignCtListGridID, "rowCheckClick", function(event){
        var assiinCd = fn_getAssionCTListCheckedRowItems();

        var editedRowItems = AUIGrid.getEditedRowItems(assignCOrdtListGridID);
        for (var i = 0; i < editedRowItems.length; i++) {
              AUIGrid.updateRow(assignCOrdtListGridID, {"memCode" :  assiinCd[0], "insstallCtId" : assiinCd[1]}, i);
        }
    });
});

function createAssignCtListAUIGrid() {

    var columnLayout = [
                        {dataField : "ctCode",     headerText:"DT Code", width:100 , editable:false} ,
                        { dataField : "ctName",    headerText:"DT Name", width:120 , editable:false},
                        { dataField : "branchName", headerText:"Branch Name", width:120},
                        { dataField : "ctSubGrp", headerText:"DT GRP",  width:120},
                        {dataField : "ctId", headerText:"DT ID", width:120, visible:true},
                        { dataField : "serialRequireChkYn", headerText : "Serial Require Check Y/N", width:180, visible:true, editable:false}
   ];

    var gridPros = { usePaging : true,
            editable : false,
            displayTreeOpen : true,
            headerHeight : 30,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
            showRowNumColumn : true,
            showRowCheckColumn : true,
            rowCheckToRadio : true
    };
    assignCtListGridID= GridCommon.createAUIGrid("aCtL_grid_wrap", columnLayout  ,"" ,gridPros);
}




//체크된 아이템 얻기
function fn_getAssionCTListCheckedRowItems() {

  var checkedItems = AUIGrid.getCheckedRowItems(assignCtListGridID);


  console.log(checkedItems);

  if(checkedItems.length  == 0  ||  checkedItems == null) {
      Common.alert("<b>No DT List selected.</b>");
      return  false ;
  }

      var str = [];
      var rowItem = checkedItems[0].item;
     str[0] = rowItem.ctCode;
     str[1] = rowItem.ctId;

     return str;
}

function createAssignCtOrderListAUIGrid() {

    var columnLayout = [
                        {
                               renderer : {
                                type : "CheckBoxEditRenderer",
                                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                                checkValue : "1", // true, false 인 경우가 기본
                                width : 20,
                                unCheckValue : "0",
                             // 체크박스 Visible 함수
                                checkableFunction  : function(rowIndex, columnIndex, value, isChecked, item, dataField) {

                                    var assiinCd = fn_getAssionCTListCheckedRowItems();
                                    if(assiinCd  ==false ) return false;

                                    if(item.c1 == 1){
                                        AUIGrid.updateRow(assignCOrdtListGridID, {
                                              "memCode" : "",
                                              "insstallCtId" : ""
                                            }, rowIndex);
                                    }else{
                                        AUIGrid.updateRow(assignCOrdtListGridID, {
                                             "memCode" :  assiinCd[0],
                                              "insstallCtId" : assiinCd[1]
                                          }, rowIndex);
                                    }
                                    return true;
                                }
                            }
                        },
                        {dataField : "custName",         headerText  : "Customer" ,width  : 150, editable:false } ,
                        { dataField : "salesOrdNo",      headerText  : "SalesOrder",  width  : 100, editable:false},
                        { dataField : "serialNo", headerText:"Serial No", width:180, height:30, headerStyle : "aui-grid-header-input-icon",
                            editRenderer : {
                                type : "ComboBoxRenderer",
                                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                listFunction : function(rowIndex, columnIndex, item, dataField) {
                                	if(item.serialChk != "Y" || item.serialRequireChkYn != "Y"){return null;}

                                	fn_ctSerialNoList(item.ctCode, item.stkCode);
                                    return serialList;
                                },
                                keyField : "code",
                                valueField : "codeName"
                            }
                        },

                        { dataField : "frmSerialNo", headerText:"Frame Serial No", width:180, height:30, headerStyle : "aui-grid-header-input-icon",
                        	editRenderer : {
                                type : "ComboBoxRenderer",
                                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                listFunction : function(rowIndex, columnIndex, item, dataField) {
                                	if(item.frmSerialChk != "Y"){return null;}

                                	fn_frmSerialNoList(item.ctCode, item.frmStkCode);
                                    return frmSerialList;
                                },
                                keyField : "code",
                                valueField : "codeName"
                            }
                        },
                        { dataField : "memCode",        headerText  : "DT Code",  width  : 80, editable:false  },
                        { dataField : "custSubGrp",     headerText  : "Cust GRP",  width  : 100, editable:false  },
                        { dataField : "insstallCtId",      headerText  : "DT ID ",  width  : 100, editable:false, visible : true},
                        { dataField : "ctId",        headerText  : "Old DT ID",  width  : 100, editable:false,    visible : false},
                        { dataField : "ctCode",        headerText  : "Old DT Code",  width  : 100   , editable:false,     visible : false},
                        { dataField : "installEntryNo",        headerText  : "Install No ",  width  : 100, editable:false,    visible : false},
                        { dataField : "stkCode", headerText : "Item Code", width : 80, editable : false},
                        { dataField : "stkDesc", headerText : "Product", width : 180, editable : false, style: "aui-grid-user-custom-left"},
                        { dataField : "serialChk", headerText : "Serial Chk", width : 80, editable : false },
                        { dataField : "serialRequireChkYn", headerText  : "Serial Require Check Y/N", width : 180, editable : false  },

                        // KR-JIN, AUX info
                        { dataField : "frmStkCode", editable:false, visible:false},
                        { dataField : "frmSerialChk", editable:false, visible:false},
                        { dataField : "frmSalesOrdNo", editable:false, visible:false},
                        { dataField : "frmInstallEntryNo", editable:false, visible:false}
   ];


    var gridPros = { usePaging : true,
                            editable : true,
                            displayTreeOpen : true,
                            headerHeight : 30,
                            skipReadonlyColumns : true,
                            wrapSelectionMove : true,
                            showRowNumColumn : true
    };
    assignCOrdtListGridID= GridCommon.createAUIGrid("aCtOrd_grid_wrap", columnLayout  ,"" ,gridPros);

    AUIGrid.bind(assignCOrdtListGridID, "cellEditBegin", function(e){
    	if(e.dataField == "serialNo"){
    		if( e.item.serialChk != "Y" || e.item.serialRequireChkYn != "Y"){
    			  return false;
    		}
    	}
    	if(e.dataField == "frmSerialNo"){
    		if( e.item.frmSerialChk != "Y"){
    			return false;
    		}
    	}
    });

}


function fn_ctChange(){

	var selectedItems = AUIGrid.getCheckedRowItems(assignCtListGridID);
	//수정된 행 아이템들(배열)
    var editedRowItems = AUIGrid.getEditedRowItems(assignCOrdtListGridID);
    var serialObj  = new Array();

    if(selectedItems.length  == 0  ||  selectedItems == null) {
        Common.alert("<b>No DT List  selected.</b>");
        return  false ;
    }

    if(editedRowItems.length  == 0  ||  editedRowItems == null) {
        Common.alert("<b>No DTOrder List  selected.</b>");
        return  false ;
    }

    var ctSerialRequireChkYn = selectedItems[0].item.serialRequireChkYn;

    for (var i = 0; i < editedRowItems.length; i++) {
        if(FormUtil.isEmpty(editedRowItems[i].insstallCtId)) {
            Common.alert("<b>No DTOrder List selected.</b>");
            return  false ;
        }

        if(ctSerialRequireChkYn != editedRowItems[i].serialRequireChkYn) {
            Common.alert("<b>'Serial Require Check Y/N' is different.</b>");
            return  false ;
        }

        if(editedRowItems[i].serialChk == 'Y' && editedRowItems[i].serialRequireChkYn == 'Y') {
            if(FormUtil.isEmpty(editedRowItems[i].serialNo)) {
                Common.alert("<b>Serial No is required.( SalesOrder : " + editedRowItems[i].salesOrdNo + " )</b>");
                return  false ;
            }
        }

        if(FormUtil.isNotEmpty(editedRowItems[i].serialNo)) {
            serialObj.push(editedRowItems[i].serialNo);
        }

        for (var k = 0; k < editedRowItems.length; k++) {
            var serialCnt = 0;
            for(var j = 0;  j < serialObj.length; j++) {
                if(editedRowItems[k].serialNo == serialObj[j]) {
                    serialCnt ++;
                }
            }

            if(serialCnt > 1) {
                Common.alert("<b>Serial No is duplicated.</b>");
                return  false ;
            }
        }
    }

    var  updateForm ={
              "update" : editedRowItems
    }

    Common.ajax("POST", "/homecare/services/install/assignCtOrderListSaveSerial.do", updateForm, function(result) {
        console.log("updateAssignCT.");
        console.log( result);

        if(result  !=""){
        	Common.alert(result.message);
        	fn_installationListSearch();
        	$("#_assginCTTransferDiv").remove();
        }
    });


}

function fn_asaAssignCtList(){
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    var  brnch_id ;
    brnch_id =selectedItems[0].item.brnchId;

    Common.ajax("GET", "/homecare/services/as/assignCtList.do",{BRNCH_ID:brnch_id}, function(result) {
        //console.log("fn_asaAssignCtList.");
        //console.log(result);

        AUIGrid.setGridData(assignCtListGridID, result);
    });
}

function fn_asaAssignCtOderList(){
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    var installNoArray =[];

    for( var  i in selectedItems){
        installNoArray.push(selectedItems[i].item.installEntryNo)
    }

    var obj =JSON.stringify(installNoArray).replace(/[\[\]\"]/gi, '') ;

    Common.ajax("GET", "/homecare/services/install/assignCtOrderList.do", {installNo:obj}, function(result) {
        //console.log("fn_asaAssignCtOderList.");
        //console.log(result);

        var isFrm = false;
        $.each(result, function(i, row){
            if(row.frmSerialChk == "Y"){
                isFrm = true;
            }
        });
        if(isFrm){
            AUIGrid.showColumnByDataField(assignCOrdtListGridID, "frmSerialNo");
        }else{
            AUIGrid.hideColumnByDataField(assignCOrdtListGridID, "frmSerialNo");
        }

        AUIGrid.setGridData(assignCOrdtListGridID, result);
    });
}

function fn_ctSerialNoList(ctCode, stkCode){
	if( v_ctCode != ctCode && v_stkCode != stkCode){
		serialList = [];
	    Common.ajaxSync("GET", "/services/selectCtSerialNoList.do", {ctCode : ctCode, stkCode : stkCode}, function(result) {
	        for ( var i = 0 ; i < result.length ; i++ ) {
	            serialList.push(result[i]);
	        }
	        v_ctCode = ctCode;
	        v_stkCode = stkCode;
	    }, function(){v_ctCode = ""; v_stkCode = "";});
	}
}

function fn_frmSerialNoList(ctCode, stkCode){
    if( v_frmCtCode != ctCode && v_frmStkCode != stkCode){
    	frmSerialList = [];
        Common.ajaxSync("GET", "/services/selectCtSerialNoList.do", {ctCode : ctCode, stkCode : stkCode}, function(result) {
            for ( var i = 0 ; i < result.length ; i++ ) {
                frmSerialList.push(result[i]);
            }
            v_frmCtCode = ctCode;
            v_frmStkCode = stkCode;
        }, function(){v_frmCtCode = ""; v_frmStkCode = "";});
    }
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Assign DT Change</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="javascript:fn_ctChange();" >Assign DT Change</a></p></li>
    <li><p class="btn_blue2"><a href="#none">CLOSE</a></p></li>
</ul>

</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<div class="divine_auto"><!-- divine_auto start -->


<div style="width: 50%;">
<aside class="title_line"><!-- title_line start -->
<h2>DT List</h2>
</aside><!-- title_line end -->

        <div class="border_box" style="height:400px"><!-- border_box start -->

        <ul class="right_btns">
        <!--     <li><p class="btn_grid"><a href="#none">EDIT</a></p></li>
            <li><p class="btn_grid"><a href="#none">NEW</a></p></li> -->
        </ul>

        <article class="grid_wrapCd"><!-- grid_wrap start -->
        <div id="aCtL_grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
        </article><!-- grid_wrap end -->

        </div><!-- border_box end -->

</div>
<div style="width:50%;">

        <aside class="title_line"><!-- title_line start -->
        <h2>DT Order List</h2>
        </aside><!-- title_line end -->

        <div class="border_box" style="height:400px; width: 450px"><!-- border_box start -->

        <ul class="right_btns">
        <!--     <li><p class="btn_grid"><a href="#none">EDIT</a></p></li>
            <li><p class="btn_grid"><a href="#none">NEW</a></p></li> -->
        </ul>

        <article class="grid_wrapCust"><!-- grid_wrap start -->
              <div id="aCtOrd_grid_wrap" style="width:100%; height: 334px; margin: 0 auto;"></div>
        </article><!-- grid_wrap end -->
        </div><!-- border_box end -->

</div>
</div>

</div><!-- divine_auto end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
