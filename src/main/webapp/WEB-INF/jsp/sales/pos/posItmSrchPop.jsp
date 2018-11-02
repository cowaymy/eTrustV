<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">

/* gride 동적 버튼 */
.edit-column {
    visibility:hidden;
}
</style>
<script type="text/javascript">

//Grid 생성 후 반환 ID
var basketGridID;
var serialConfirmGridID;

//Init Option
var ComboOption = {
        type: "S",
        chooseMessage: "Select Item Type",
        isShowChoose: false  // Choose One 등 문구 보여줄지 여부.
};

var ItmOption = {
        type: "M",
        isCheckAll: false
};

var reasonOption = {
        type: "S",
        chooseMessage: "Select Reason",
};
$(document).ready(function() {

	//Create Grid
	fn_createBasketGrid(); //basket
	fn_createSerialConfirmGrid(); //Serial

	//Init
	fn_initField();
	///getReasonCodeList
	var rsnParam = {masterCode : 1363};
	CommonCombo.make('_purcReason', "/sales/pos/getReasonCodeList", rsnParam , '', reasonOption); //Reason Code List

	//Change Func
    $("#_purcItemType").change(function() {

    	if ($(this).val() != null && $(this).val() != '' ) {
    		//Filed Enabled
            $("#_purcItems").attr({"disabled" : false , "class" : "w100p"});

            if($("#_posSystemType").val() == 1352){  //Filter
            	var itmType = {itemType : $(this).val() , posSal : 1};
            	CommonCombo.make('_purcItems', "/sales/pos/selectPosItmList", itmType , '', ItmOption);
            }

            if($("#_posSystemType").val() == 1353){  //Item Bank
            	var itmType = {itemType : $(this).val() , posItm : 1};
            	CommonCombo.make('_purcItems', "/sales/pos/selectPosItmList", itmType , '', ItmOption);
            }

            if($("#_posSystemType").val() == 1357){ // Other Income
            	var itmType = {itemType : $(this).val() , posOth : 1};
            	CommonCombo.make('_purcItems', "/sales/pos/selectPosItmList", itmType , '', ItmOption);
            }

            if($("#_posSystemType").val() == 1358){ // Item Bank HQ
                var itmType = {itemType : $(this).val() , posOth : 1};
                CommonCombo.make('_purcItems', "/sales/pos/selectPosItmList", itmType , '', ItmOption);
            }
		}

	});//Change Func End

    $("#_basketAdd").click(function() {

    	//Validation
    	//Null check
    	if($("#_purcItems").val() == null || $("#_purcItems").val() == ''){
    		Common.alert("No Selected Items.");
    		return;
    	}

    	//Check Duplication of Basket , ItemList
    	var basketCodeArray = AUIGrid.getColumnValues(basketGridID, 'stkId');
    	var values = $("#_purcItems").val();
    	var msg = '';
    	for (var idx = 0; idx < basketCodeArray.length; idx++) {
    		for (var i = 0; i < values.length; i++) {

    			console.log("basketCodeArray[idx] : " + basketCodeArray[idx]);
    			console.log("values[i] : " + values[i]);

    			if(basketCodeArray[idx] == values[i]){
    				msg += $("#_purcItems").find("option[value='"+values[i]+"']").text();
    				Common.alert("* " + msg +'<spring:message code="sal.alert.msg.isExistInList" />');
    				return;
    			}
			}
		}

    	//Validation Success
    	// 1 . filter
    	if($("#_posSystemType").val() == 1352){

            Common.ajax('GET', '/sales/pos/chkStockList2', $("#_itemSrcForm").serialize(), function(result) {

                for (var i = 0; i < result.length; i++) {
                   var calResult = fn_calculateAmt(result[i].amt, 1);
                   result[i].subTotal  = calResult.subTotal;
                   result[i].subChanges = calResult.subChanges;
                   result[i].taxes  = calResult.taxes;
                   result[i].inputQty = 1;
               }

                //GridSet
                /* AUIGrid.setGridData(basketGridID, result); */
                AUIGrid.addRow(basketGridID, result, 'last');
                fn_reasonFieldContorl();

            });
    	}

    	// 2. item bank
    	if($("#_posSystemType").val() == 1353){ //// Pos Item Bank 창고 Query Fix
    		//id="chkStockList"

            Common.ajax('GET', '/sales/pos/chkStockList', $("#_itemSrcForm").serialize(), function(result) {

                for (var i = 0; i < result.length; i++) {
                   var calResult = fn_calculateAmt(result[i].amt, 1);
                   result[i].subTotal  = calResult.subTotal;
                   result[i].subChanges = calResult.subChanges;
                   result[i].taxes  = calResult.taxes;
                   result[i].inputQty = 1;
               }

                //GridSet
                /* AUIGrid.setGridData(basketGridID, result); */
                //_purcReason
                AUIGrid.addRow(basketGridID, result, 'last');

            });
    	}


    	// 3. Other Income
    	if($("#_posSystemType").val() == 1357){ //// Other Income 창고 Query Fix

    		Common.ajax('GET', '/sales/pos/chkStockList', $("#_itemSrcForm").serialize(), function(result) {

                for (var i = 0; i < result.length; i++) {
                   var calResult = fn_calculateAmt(result[i].amt, 1);
                   result[i].subTotal  = calResult.subTotal;
                   result[i].subChanges = calResult.subChanges;
                   result[i].taxes  = calResult.taxes;
                   result[i].inputQty = 1;
               }

                //GridSet
                /* AUIGrid.setGridData(basketGridID, result); */
                //_purcReason
                AUIGrid.addRow(basketGridID, result, 'last');
            });
    	}

    	// 4. Item Bank HQ
        if($("#_posSystemType").val() == 1358){ //// Other Income 창고 Query Fix

            Common.ajax('GET', '/sales/pos/chkStockList', $("#_itemSrcForm").serialize(), function(result) {

                for (var i = 0; i < result.length; i++) {
                   var calResult = fn_calculateAmt(result[i].amt, 1);
                   result[i].subTotal  = calResult.subTotal;
                   result[i].subChanges = calResult.subChanges;
                   result[i].taxes  = calResult.taxes;
                   result[i].inputQty = 1;
               }

                //GridSet
                /* AUIGrid.setGridData(basketGridID, result); */
                //_purcReason
                AUIGrid.addRow(basketGridID, result, 'last');
            });
        }
	});

	//Delete Low
	$("#_chkDelBtn").click(function() {

		//1. basketGrid == cheked Items
		var chkDelArray = AUIGrid.getCheckedRowItems(basketGridID);
		//2. serialGrid == all Items
		var serialItemArray  = AUIGrid.getColumnValues(serialConfirmGridID, 'matnr');
		//3. Serial Check
 		var delArr = [];
		for (var idx = 0; idx < chkDelArray.length; idx++) {
			for (var i = 0; i < serialItemArray.length; i++) {
				if(chkDelArray[idx].item.stkCode == serialItemArray[i]){
					delArr.push(i);
				}
			}
		}
		//4. Delete Serial Number
		if(delArr != null && delArr.length > 0){
			AUIGrid.removeRow(serialConfirmGridID, delArr);
		}
		//5. Remove Check Low
		AUIGrid.removeCheckedRows(basketGridID);
		//6. Filter Check and Control Reason Field
		fn_reasonFieldContorl();

	});


	//Save
	$("#_itemSrchSaveBtn").click(function() {
		//Validation
		//1 .장바구니 물품 Null Check
		var valChk = true;
		var nullChkNo = AUIGrid.getRowCount(basketGridID);
	//	console.log(' nullChkNo(row 개수) : ' + nullChkNo);
		if(nullChkNo == null || nullChkNo < 1){
			Common.alert('<spring:message code="sal.alert.msg.selectItm" />');
			return;
		}
		//2. 장바구니 수량 중  0 이 있는지 체크
		var ivenChkArr = AUIGrid.getColumnValues(basketGridID, 'qty');
		$(ivenChkArr).each(function(idx, el) {
            if(ivenChkArr[idx] == 0){
                valChk = false;
                return false;
            }
        });
		if( valChk == false){
			Common.alert('<spring:message code="sal.alert.msg.listNoInvItm" />');
			return;
		}

		//3. 장바구니 가격 중 0  이 있는지 체크
		var prcChkArr = AUIGrid.getColumnValues(basketGridID, 'amt'); // Amt
		$(prcChkArr).each(function(idx, el) {
			if(prcChkArr[idx] == 0){
				valChk = false;
				return false;
			}
		});
		if(valChk == false){
			Common.alert('<spring:message code="sal.alert.msg.listNoPrcItm" />');
            return;
		}
		//4. 장바구니에 입력한 수량이 0 이 있는지 체크
		var qtyChkArr = AUIGrid.getColumnValues(basketGridID, 'inputQty'); //input Quantity
        $(qtyChkArr).each(function(idx, el) {
            if(qtyChkArr[idx] == 0){
            	valChk = false;
            	return false;
            }
        });
        if(valChk == false){
        	Common.alert('<spring:message code="sal.alert.msg.keyInQty" />');
            return;
        }
        //5. inventory 수량 보다 입력한 수량값이 넘는지 체크
        if(ivenChkArr.length == qtyChkArr.length){
        	$(ivenChkArr).each(function(idx , el) {
        		//console.log('인벤토리 : '  +  ivenChkArr[idx] + ' , 구입수량 : ' + qtyChkArr[idx] + ' , el : ' + el);
        		if(ivenChkArr[idx] < qtyChkArr[idx]){
					valChk = false;
					return false;
				}
			});
        	if(valChk == false){
        		Common.alert('<spring:message code="sal.alert.msg.shortOfVol" />');
        		return;
        	}
        }else{
        	Common.alert('<spring:message code="sal.alert.msg.failedToNewItm" />');
        	return;
        }
		//6. 장바구니 리스트 중에 필터가 있을 경우  stkTypeId == 62
		var typeArr = AUIGrid.getColumnValues(basketGridID, 'stkTypeId'); //Type Chk
		var filterChkFlag = false;

		$(typeArr).each(function(idx, el) {
			if(typeArr[idx] == 62){ //filter
				filterChkFlag = true;
		        return false;
	        }
		});
		if(filterChkFlag ==true){ //필터가 있을 때
			//6 - 1. 필터인데 reason 선택했는지 체크
			if( null == $("#_purcReason").val() || '' == $("#_purcReason").val()){
				Common.alert('<spring:message code="sal.alert.msg.keyInPosResn" />');
				return;
			}
			//6 - 2. 필터인데 해당 시리얼 번호를 입력한 수량에 맞는 개수를 가져왔는지 체크
		//	var itemCodeArr = AUIGrid.getColumnValues(basketGridID, 'stkCode'); //Stock Code List
			var idxObj;
			var serialCodeArr = AUIGrid.getColumnValues(serialConfirmGridID, 'matnr');

			for (var idx = 0; idx < nullChkNo; idx++) {
				idxObj = AUIGrid.getItemByRowIndex(basketGridID, idx); //해당 index행  가져오기 // item // basket
				if(idxObj.stkTypeId == 62 && idxObj.serialChk == 'Y'){// filter
					//idxObj.stkCode(String) 를  가지고 있는 serialGrid 와 매칭  serialCodeArr(Array)
					var serialCnt = 0;
					for (var i = 0; i < serialCodeArr.length; i++) {
						if(idxObj.stkCode == serialCodeArr[i]){
							serialCnt++;
						}
					}//loop end
					// cnt 와 qty 매칭  // serialCnt == idxObj.inputQty
////////////////////////////////////////  Serial Number Check ///////////////////////////////////////////////////  추후 시리얼 번호 관리시 주석 해제
				    if(serialCnt != idxObj.inputQty){
						Common.alert('<spring:message code="sal.alert.msg.chkFilterNotMatch" />');
						return;
					}
////////////////////////////////////////Serial Number Check ///////////////////////////////////////////////////

				 /*     //TEMP LOGIC  추후 시리얼 번호 관리시 로직 삭제
				    if(serialCnt < idxObj.inputQty){
				    	var tempLength = 0;
				    	tempLength = idxObj.inputQty - serialCnt;
				    	for (var j = 0; j < tempLength; j++) {
				    		var result = Math.floor(Math.random() * 100) + 1;
				    		if(result < 100 && result > 9){
				    			result = 'efg000'+result + '0000000';
				    		}else if(result > 99){
				    			result = '000efg000'+result+'000';
				    		}else{
				    			result = '000000efg00000'+result;
				    		}
				    		console.log("random serial no : " + result);
                            var addObj = {matnr : idxObj.stkCode , stkDesc : idxObj.stkDesc , serialNo : result , stkId : idxObj.stkId};

				    		AUIGrid.addRow(serialConfirmGridID, addObj, 'first');
						}
				    }else if(serialCnt > idxObj.inputQty){
				    	Common.alert("Serial number quantities can not be more than the quantity entered.");
				    	return;
				    }// Temp Logic */
				}else{
					console.log("not Filter");
				}
				//Exsit Filter
				$("#_mainSerialGrid").css("display" , "");
			}//loop end
		}

		//Vaidaton Success
        var finalPurchGridData = AUIGrid.getGridData(basketGridID);
		/* console.log(" finalPurchGridData : " + finalPurchGridData);
		console.log(" finalPurchGridData[0] : " + finalPurchGridData[0]);
		console.log(" finalPurchGridData[0].stkCode : " + finalPurchGridData[0].stkCode); */
		var filterPurchGridData = AUIGrid.getGridData(serialConfirmGridID);
		//setGrid for Purchase
		getItemListFromSrchPop(finalPurchGridData, filterPurchGridData);
		//close window
        $("#_posReason").val($("#_purcReason").val());
		$("#_itmSrchPopClose").click();

	});


	//Check Amt Can be Modifiy
	AUIGrid.bind(basketGridID, "cellEditBegin", function( event ) {

		if(event.dataField == 'amt'){
			var chkParam = {stkId : event.item.stkId};
	        var isEdit = false;
	        var ajaOpt = { async : false};
	        Common.ajax("GET", "/sales/pos/chkAllowSalesKeyInPrc", chkParam, function (result){
	             isEdit =  result;
	        }, null, ajaOpt);

	        //Force Editing
	        AUIGrid.forceEditingComplete(basketGridID, null, false);

	        return isEdit;
		}else if(event.dataField == 'inputQty'){
			return true;
		}else{
			return false;
		}
	});

	//Edit Grid by Half Round
	AUIGrid.bind(basketGridID, "cellEditEndBefore", function( event ) {

	//	console.log("event.dataField : " + JSON.stringify(event.dataField));

		if(event.dataField == 'amt'){
			var fixVal = 0 ;
	        fixVal = event.value.toFixed(2);

	     //   console.log("event.value : " + event.value);
	     //   console.log("fixVal : " + fixVal);
	        return fixVal; // 사용자가 입력한 값에 컴마가 있으면 제거 후 적용
		}

		if(event.dataField == 'inputQty'){
			var inputQty = event.value;
			var times = 1;
			var girdLeng;
			if($("#_insPosModuleType").val() == 2391){
				girdLeng = AUIGrid.getGridData(memGridID);
				times = girdLeng.length;
			}

			if(isNaN(inputQty)){
				inputQty = 0;
			}else{
				if(inputQty <= 0){
	                inputQty = 0;
	            }else{
	                inputQty = Math.ceil(inputQty);
	            }
			}

		//	console.log("inputQty : " + inputQty);
		//	console.log("times : " + times);
			//return inputQty*times;
			return inputQty;
		}
	});

});//Doc Ready Func End

function fn_getConfirmFilterListAjax(rtnObject){

    Common.ajax("GET", "/sales/pos/getConfirmFilterListAjax", rtnObject , function(result) {

        /* AUIGrid.setGridData(serialConfirmGridID, result); */
    	 AUIGrid.addRow(serialConfirmGridID, result, 'last');

    });

}


function fn_createSerialConfirmGrid(){

	var serialGridPros = {

	        usePaging           : true,         //페이징 사용
	        pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
	        fixedColumnCount    : 1,
	        showStateColumn     : false,
	        displayTreeOpen     : false,
	//        selectionMode       : "singleRow",  //"multipleCells",
	        headerHeight        : 30,
	        useGroupingPanel    : false,        //그룹핑 패널 사용
	        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
	        softRemoveRowMode : false,
	        showRowCheckColumn : false
	};

	 var seriaConfirmlColumnLayout =  [
                                {dataField : "matnr", headerText : '<spring:message code="sal.title.filterCode" />', width : '33%' , editable : false} ,
                                {dataField : "stkDesc", headerText :'<spring:message code="sal.title.filterName" />', width : '33%' , editable : false},
                                {dataField : "serialNo", headerText : '<spring:message code="sal.title.serial" />', width : '33%' , editable : false},
                                {dataField : "stkId" , visible : true}
                               ];

	 serialConfirmGridID = GridCommon.createAUIGrid("#serial_grid_wrap", seriaConfirmlColumnLayout,'', serialGridPros);
     AUIGrid.resize(serialConfirmGridID , 960, 300);
}


function fn_reasonFieldContorl() {

	//Filter 유무 확인 후 Reason 필드 Open , Close
    //getColumnDistinctValues
    var typeArray = []
    typeArray = AUIGrid.getColumnDistinctValues(basketGridID , 'stkTypeId');
    //console.log('typeArray : ' + typeArray);
    var reasonCnt = 0;

    if(typeArray != null && typeArray.length > 0){

        for (var idx = 0; idx < typeArray.length; idx++) {
            if(typeArray[idx] == '62'){
                reasonCnt++;
                break;
            }
        }


        $("#_purcReason").attr({"disabled" : false , "class" : "w100p"});
/*           if (reasonCnt > 0) {
        	$("#_purcReason").attr({'disabled' : false , 'class' : 'w100p'});
		}else{
			$("#_purcReason").attr({'disabled' : 'disabled' , 'class' : 'w100p disabled'});
            $("#_purcReason").val('');
		}
 */
     }
     else{
     	$("#_purcReason").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_purcReason").val('');

    }

}


//addcolum button hidden
function cellStyleFunction(rowIndex, columnIndex, value, headerText, item, dataField){

	if(item.stkTypeId == '62'){
		//SERIAL_CHK
		if(item.serialChk != null &&  item.serialChk == 'Y'){
			return '';
		}else{
			return "edit-column";
		}
	}else{
		return "edit-column";
	}
}

//Calculate


function fn_createBasketGrid(){

	 var basketColumnLayout =  [
	                            {dataField : "stkCode", headerText : '<spring:message code="sal.title.itemCode" />', width : '10%' , editable : false},
	                            {dataField : "stkDesc", headerText : '<spring:message code="sal.title.itemDesc" />', width : '30%', editable : false},
	                            {dataField : "qty", headerText : '<spring:message code="sal.title.inventory" />', width : '10%', editable : false},
	                            {dataField : "inputQty", headerText : '<spring:message code="sal.title.qty" />', width : '10%', editable : true, dataType : "numeric"},
	                            {dataField : "amt", headerText :'<spring:message code="sal.title.unitPrice" />', width : '10%', dataType : "numeric", formatString : "#,##0.00",editRenderer : {
	                                type : "InputEditRenderer",
	                                onlyNumeric : true,
	                                allowPoint : true
	                            }},
	                            {dataField : "subChanges", headerText : '<spring:message code="sal.title.excludeGST" />', width : '10%', editable : false , dataType : "numeric", formatString : "#,##0.00",expFunction : function(  rowIndex, columnIndex, item, dataField ) {
	                                var subObj = fn_calculateAmt(item.amt , item.inputQty);
	                                return Number(subObj.subChanges);
	                            }},
	                            {dataField : "taxes", headerText : 'GST(0%)', width : '10%', editable : false , dataType : "numeric", formatString : "#,##0.00", expFunction : function(  rowIndex, columnIndex, item, dataField ) {
	                                var subObj = fn_calculateAmt(item.amt , item.inputQty);
	                                return Number(subObj.taxes);
	                            }},
	                            {
	                                dataField : "undefined",
	                                headerText : '<spring:message code="sal.title.serial" />',
	                                width : '10%',
	                                styleFunction : cellStyleFunction,
	                                renderer : {
	                                         type : "ButtonRenderer",
	                                         labelText : '<spring:message code="sal.title.serial" />',
	                                         onclick : function(rowIndex, columnIndex, value, item) {

	                                        	 //filter Grid`s Serial No
	                                        	 var tempSerialArr = AUIGrid.getColumnValues(serialConfirmGridID, 'serialNo');
	                                        	 var tempString = tempSerialArr.toString();
	                                        	/*  console.log('tempString type : ' + $.type(tempString));
	                                        	 console.log("tempString : " + tempString); */
	                                        	 var arrParam  = {basketStkCode : item.stkCode , tempString : tempString};
                                                 Common.popupDiv("/sales/pos/posFilterSrchPop.do", arrParam , null, true);
	                                         }
	                                }
	                            },
	                            {dataField : "stkTypeId" , visible :false},
	                            {dataField : "serialChk" , visible :false}, ////SERIAL_CHK
	                            {dataField : "stkId" , visible :false}//STK_ID
	                           ];

	    //그리드 속성 설정
	    var gridPros = {

	            usePaging           : true,         //페이징 사용
	            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
	            fixedColumnCount    : 1,
	            showStateColumn     : false,
	            displayTreeOpen     : false,
	   //         selectionMode       : "singleRow",  //"multipleCells",
	            headerHeight        : 30,
	            useGroupingPanel    : false,        //그룹핑 패널 사용
	            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
	            softRemoveRowMode : false,
	            showRowCheckColumn : true
	    };

	    basketGridID = GridCommon.createAUIGrid("#basket_grid_wrap", basketColumnLayout,'', gridPros);
	    AUIGrid.resize(basketGridID , 960, 300);

}

function fn_initField(){
	//ComboBox Options
	//Init -- Item Type ComboBox

	var tempModule =  $("#_posModuleType").val();
	var tempSysType = $("#_posSystemType").val();

//	console.log("tempModule : " + tempModule);
// console.log("tempSysType : " + tempSysType);

	if($("#_posModuleType").val() == 2390){ //2390 == POS Sales

	    if($("#_posSystemType").val() == 1352){ ////Pos Filter / Spare Part / Miscellaneous 창고 선택시
	    	$("#_gridArea").css("display" , "");  //Serial Grid Display None
	    	//Type
	    	var codes = [61 , 62 , 63 , 64 , 1370];
	    	var codeM = {codeM : 15 , codes : codes};
	        CommonCombo.make('_purcItemType', "/sales/pos/selectPosTypeList", codeM , '', ComboOption);
	       //Itm List
	        var itmType = {itemType : 61 , posSal : 1};
	        CommonCombo.make('_purcItems', "/sales/pos/selectPosItmList", itmType , '', ItmOption);
	    }

	    if($("#_posSystemType").val() == 1353){ //// Pos Item Bank 창고 Query Fix

	    	$("#_gridArea").css("display" , "none");  //Serial Grid Display None
	    	//Type
	    	var codes = [1345 , 1346 , 1347 , 1348 , 1362];
            var codeM = {codeM : 11 , codes : codes};
	        CommonCombo.make('_purcItemType', "/sales/pos/selectPosTypeList", codeM , '', ComboOption);
	        //Itm List
	        var itmType = {itemType : 1345 , posItm : 1};
	        CommonCombo.make('_purcItems', "/sales/pos/selectPosItmList", itmType , '', ItmOption);
	    }
	}

	if($("#_posModuleType").val() == 2391){ //2391 == Deduction Commission

		if($("#_posSystemType").val() == 1352){ ////Pos Filter / Spare Part / Miscellaneous 창고 선택시
			//Type
			var codes = [61 , 62 , 63 , 64 , 1370];
            var codeM = {codeM : 15 , codes : codes};
			$("#_gridArea").css("display" , "none");  //Serial Grid Display None
            CommonCombo.make('_purcItemType', "/sales/pos/selectPosTypeList", codeM , '', ComboOption);
            //Itm List
            var itmType = {itemType : 61 , posSal : 1};
            CommonCombo.make('_purcItems', "/sales/pos/selectPosItmList", itmType , '', ItmOption);
        }

		if($("#_posSystemType").val() == 1353){ // Pos Item Bank 창고 Query Fix
			//Type
			var codes = [1345 , 1346 , 1347 , 1348 , 1362];
            var codeM = {codeM : 11 , codes : codes};
            CommonCombo.make('_purcItemType', "/sales/pos/selectPosTypeList", codeM , '', ComboOption);
            //Itm List
            $("#_gridArea").css("display" , "none"); //Serial Grid Display None
            var itmType = {itemType : 1345 , posItm : 1};
            CommonCombo.make('_purcItems', "/sales/pos/selectPosItmList", itmType , '', ItmOption);
        }
	}

	if($("#_posModuleType").val() == 2392){ //2392  == Other Income

		if($("#_posSystemType").val() == 1357){ // Other Income

			$("#_gridArea").css("display" , "none");  //Serial Grid Display None

	        var codes = [1348 , 1349 , 1350];
	        var codeM = {codeM : 11 , codes : codes};
	        CommonCombo.make('_purcItemType', "/sales/pos/selectPosTypeList", codeM , '', ComboOption);

	        //Itm List
	        var itmType = {itemType : 1348 , posOth : 1};
	        CommonCombo.make('_purcItems', "/sales/pos/selectPosItmList", itmType , '', ItmOption);
		}

	    if($("#_posSystemType").val() == 1358){ // Item Bank HQ

	    	$("#_gridArea").css("display" , "none");  //Serial Grid Display None

	    	var codes = [1345 , 1346 , 1347  , 1362 , 1426];
            var codeM = {codeM : 11 , codes : codes};
            CommonCombo.make('_purcItemType', "/sales/pos/selectPosTypeList", codeM , '', ComboOption);

            //Itm List
            var itmType = {itemType : 1345 , posOth : 1};
            CommonCombo.make('_purcItems', "/sales/pos/selectPosItmList", itmType , '', ItmOption);

        }
	}
}


//조회조건 combo box
function f_multiCombo(){
    $(function() {
        $('#_purcItems').change(function() {

        }).multipleSelect({
            selectAll: false, // 전체선택
            width: '80%'
        });
    });
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<!-- get Values from Controller -->
<input type="hidden" id="_posModuleType" name="posModuleType" value="${posSystemModuleType}">
<input type="hidden" id="_posSystemType" value="${posSystemType}" >
<input type="hidden" id="_whBrnchId" value="${whBrnchId}">

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.purcItmSrch" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_itmSrchPopClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
    <li><p class="btn_blue"><a id="_basketAdd"><spring:message code="sal.btn.add" /></a></p></li>
</ul>

<form id="_itemSrcForm">

<input type="hidden" id="_locId" name="locId" value="${whBrnchId}">

<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.itmType" /></th>
    <td>
    <select class="w100p" id="_purcItemType"></select>
    </td>
    <th scope="row"><spring:message code="sal.title.item" /></th>
    <td>
    <select class="w100p" id="_purcItems" name="itmLists"></select>
    </td>
</tr>
<tr>
<th scope="row"><spring:message code="sal.title.posResn" /></th>
    <td>
    <!-- <select class="w100p disabled" id="_purcReason" name="purcReason" disabled="disabled"> -->
    <select class="w100p" id="_purcReason" name="purcReason" disabled="disabled" >
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.itmList" /></h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a id="_chkDelBtn"><spring:message code="sal.btn.delete" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="basket_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<!-- <aside class="title_line">title_line start
<h2>Purchase Items</h2>
</aside>title_line end

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">SERIAL</a></p></li>
</ul> -->
<div id="_gridArea">

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.filterSerialInfo" /></h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="serial_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</div>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="_itemSrchSaveBtn"><spring:message code="sal.btn.save2" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->