<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

//AUIGrid 생성 후 반환 ID
var posGridID;

var posItmDetailGridID;

var optionModule = {
        type: "S",                  
        isShowChoose: false  
};
var optionSystem = {
        type: "M",                  
        isShowChoose: false  
};

//Grid in SelectBox  - Selcet value
var arrPosStusCode; //POS GRID
var arrItmStusCode;  //ITEM GRID
var arrMemStusCode; //MEMBER GRID

//Ajax async
var ajaxOtp= {async : false};

$(document).ready(function() {

    
    fn_getStatusCode('9');
    fn_getStatusCode('10');
    fn_getStatusCode('11');
    createAUIGrid();
    createPosItmDetailGrid();
    girdHide();
    
     /*######################## Init Combo Box ########################*/
     
    //PosModuleTypeComboBox
    var moduleParam = {groupCode : 143, codeIn : [2392]};
    CommonCombo.make('cmbPosTypeId', "/sales/pos/selectPosModuleCodeList", moduleParam , '', optionModule);
    
    //PosSystemTypeComboBox
    var systemParam = {groupCode : 140 , codeIn : [1357, 1358 ,1361]};

    CommonCombo.make('cmbSalesTypeId', "/sales/pos/selectPosModuleCodeList", systemParam , '', optionModule);

    //selectStatusCodeList
    var statusParam = {groupCode : 9};
    CommonCombo.make('cmbStatusTypeId', "/sales/pos/selectStatusCodeList", statusParam , '', optionSystem);
    
    //branch List
    CommonCombo.make('cmbWhBrnchId', "/sales/pos/selectWhBrnchList", '' , '', '');
    
   //Wh List
    $("#cmbWhBrnchId").change(function() {
        
        var tempVal = $(this).val();
        if(tempVal == null || tempVal == '' ){
            $("#cmbWhId").val("");
        }else{
            var paramObj = {brnchId : tempVal};
            Common.ajax('GET', "/sales/pos/selectWarehouse", paramObj,function(result){
                
                if(result != null){
                    $("#cmbWhId").val(result.whLocDesc);    
                }else{
                    $("#cmbWhId").val('');
                }
            });
        }
    });
    
   
   $("#cmbSalesTypeId").change(function() {
	   //clear field
	   $("#cmbWhBrnchId").val('');
	   $("#cmbWhId").val('');
	   
	   if(this.value == 1358){ //hq
		   $("#cmbWhBrnchId").attr({"disabled" : false  , "class" : ""});
	   }else{  //other
		   $("#cmbWhBrnchId").attr({"disabled" : "disabled", "class" : "disabled"});
	   }
   });
    /*######################## Init Combo Box ########################*/
    
    //cmbPosTypeId Change Func
    $("#cmbPosTypeId").change(function() {
        
        var tempVal = $(this).val();
        
        if(tempVal == 2392){
            var systemParam = {groupCode : 140 , codeIn : [1357]};
            var optionSystem = {
                    type: "M",                  
                    isShowChoose: false  
            };
            CommonCombo.make('cmbSalesTypeId', "/sales/pos/selectPosModuleCodeList", systemParam , '', optionSystem);
        }else{
            var systemParam = {groupCode : 140 , codeIn : [1352, 1353 , 1361]};
            var optionSystem = {
                    type: "M",                  
                    isShowChoose: false  
            };
            CommonCombo.make('cmbSalesTypeId', "/sales/pos/selectPosModuleCodeList", systemParam , '', optionSystem);
        }
        
    });
    
    //Member Search Popup
    $('#memBtn').click(function() {
        Common.popupDiv("/common/memberPop.do", $("#searchForm").serializeJSON(), null, true);
    });

    $('#salesmanCd').change(function(event) {

        var memCd = $('#salesmanCd').val().trim();

        if(FormUtil.isNotEmpty(memCd)) {
            fn_loadOrderSalesman(0, memCd);
        }
    });
    
    //Search
    $("#_search").click(function() {
    	
    	AUIGrid.clearGridData(posGridID);
    	AUIGrid.clearGridData(posItmDetailGridID);
    	
    	//Validation   
        if(FormUtil.isEmpty($('#_sDate').val()) || FormUtil.isEmpty($('#_eDate').val())) {
                Common.alert("* Please select order date<br/>");
                return;
        }
        
        var startDate = $('#_sDate').val();
        var endDate = $('#_eDate').val();
        
        if( fn_getDateGap(startDate , endDate) > 31){
            Common.alert("Start date can not be more than 31 days before the end date.");
            return;
        }
    	
    	
    	
        fn_getPosListAjax();
    });
    
    //Pos System
    $("#_systemBtn").click(function() {
        Common.popupDiv("/sales/pos/posSystemOthPop.do", '', null , true , '_insDiv');
    });
    
    //Pos Reversal
    $("#_reversalBtn").click(function() {
        
        var clickChk = AUIGrid.getSelectedItems(posGridID);
        //Validation
        if(clickChk == null || clickChk.length <= 0 ){
            Common.alert("* No Order Selected. ");
            return;
        }
        
        if(clickChk[0].item.posTypeId == 1361){  //reversal
            Common.alert("* Reversal POS are prohibited!");
            return;
        }
        
        // Invoice Chk
        var reRefNo = clickChk[0].item.posNo;
        var reObject = { reRefNo : reRefNo};
        var chkRv = true;
        
        Common.ajax("GET", "/sales/pos/chkReveralBeforeReversal", reObject, function(result) {
        	if(result != null){
                chkRv = false;
            }        
        }, null ,ajaxOtp);
        
        if(chkRv == false){
            Common.alert("* Reversal POS are prohibited!");
            return;
        }
        //TODO payment 완료 후 추가 Validation 
        // IsPaymentKnowOffByPOSNo
        
        
        //TODO Check Auth
        
        //Call controller
        var reversalForm = { posId : clickChk[0].item.posId };
        
        if($("#cmbSalesTypeId").val() == 1358){
        	Common.popupDiv("/sales/pos/posReversalPop.do", reversalForm , null , true , "_revDiv");
        }else{
        	Common.popupDiv("/sales/pos/posReversalOthPop.do", reversalForm , null , true , "_revDiv");        	
        }
        
        
        
    });
    
    //Cell Click Event
    AUIGrid.bind(posGridID, "cellClick", function(event){
        
        //clear data
        AUIGrid.clearGridData(posItmDetailGridID);  
        
        if(event.item.posModuleTypeId == 2392){ // POS SALES
            
            //Mybatis Separate Param
            //1. Grid Display Control
            $("#_itmDetailGridDiv").css("display" , "");
            
            
            //2. Grid Set Data
            var itembankType = '';
            itembankType = event.item.posTypeId;
            
            var detailParam = {itembankType : itembankType , rePosId : event.item.posId};
            //Ajax
            Common.ajax("GET", "/sales/pos/getPosDetailList", detailParam, function(result){
                AUIGrid.setGridData(posItmDetailGridID, result);
            }); 
        }
    });

    
    
    /***************** Status Change  *****************/
    // 1) Pos Master Update
    $("#_posStatusBtn").click(function() {
        
    	
    	var rowCnt = AUIGrid.getRowCount(posGridID);
        if(rowCnt <= 0 ){
            Common.alert("* please Search First.");
            return;
        }
        var updateList = AUIGrid.getEditedRowItems(posGridID);
        console.log("updateList(type) : " + $.type(updateList));
        
        if(updateList == null || updateList.length <= 0 ){
            Common.alert("* No data Change.");
            return;
        }
        
    	var PosGridVO = {posStatusDataSetList : GridCommon.getEditData(posGridID)}; // name Careful
    	
		Common.ajax("POST", "/sales/pos/updatePosMStatus", PosGridVO, function(result) {
			
			Common.alert(result.message);
			AUIGrid.clearGridData(posItmDetailGridID);
			fn_getPosListAjax();
		});
	});
    
   // 2) Pos Detail Update
    $("#_itemStatusBtn").click(function() {
        
    	var rowCnt = AUIGrid.getRowCount(posItmDetailGridID);
        if(rowCnt <= 0 ){
            Common.alert("* please Search Item(s).");
            return;
        }
        var updateList = AUIGrid.getEditedRowItems(posItmDetailGridID);
        console.log("updateList(type) : " + $.type(updateList));
        
        if(updateList == null || updateList.length <= 0 ){
            Common.alert("* No data Change.");
            return;
        }
        
    	var PosGridVO = {posDetailStatusDataSetList : GridCommon.getEditData(posItmDetailGridID)}; //  name Careful = PARAM NAME SHOULD BE EQUAL VO`S NAME
        
        Common.ajax("POST", "/sales/pos/updatePosDStatus", PosGridVO, function(result) {
            
            Common.alert(result.message);
            AUIGrid.clearGridData(posItmDetailGridID);  
            fn_getPosListAjax();
        });
    });
   
    /***************  Pos Grid Status ********************/
    //1) Master
    AUIGrid.bind(posGridID, "cellEditBegin", function(event) {
           //Reversal
            if(event.item.posTypeId == 1361){
                Common.alert("* Can not Change Status ");
                return false;
            }
           // Active NonReceive Only
            if(event.value != 1 && event.value != 96){
               Common.alert("* Can not Change Status ");
               return false;
           }
           
           //Others
           return true;
   });
    // 2) Detail
    AUIGrid.bind(posItmDetailGridID, "cellEditBegin", function(event) {
        
        if(event.item.posTypeId == 1361){
            Common.alert("* Reversal  can not Change  Status");
            return false;
        }
        // Active NonReceive Only
         if(event.value != 96){
            Common.alert("* Can not Change Status ");
            return false;
        }
        //Others
        return true;
    });
});//Doc ready Func End


function girdHide(){
    //Grid Hide
    $("#_itmDetailGridDiv").css("display" , "none");
}

function createPosItmDetailGrid(){
    var posItmColumnLayout =  [ 
                                {dataField : "stkCode", headerText : "Item Code", width : '10%' , editable : false}, 
                                {dataField : "stkDesc", headerText : "Item Description", width : '30%' , editable : false},
                                {dataField : "qty", headerText : "Qty", width : '10%' , editable : false},
                                {dataField : "amt", headerText : "Unit Price", width : '10%' , dataType : "numeric", formatString : "#,##0.00" , editable : false}, 
                                {dataField : "chrg", headerText : "Sub Total(Exclude GST)", width : '10%', dataType : "numeric", formatString : "#,##0.00" , editable : false},
                                {dataField : "txs", headerText : "GST(6%)", width : '10%', dataType : "numeric", formatString : "#,##0.00" , editable : false},
                                {dataField : "tot", headerText : "Total Amount", width : '10%', dataType : "numeric", formatString : "#,##0.00" , editable : false},
                                { dataField : "rcvStusId",  headerText : "rcvStusId", width : '10%',
                                    labelFunction : function( rowIndex, columnIndex, value, headerText, item) { 
                                         var retStr = "";
                                         for(var i=0,len=arrItmStusCode.length; i<len; i++) {
                                             if(arrItmStusCode[i]["codeId"] == value) {
                                                 retStr = arrItmStusCode[i]["codeName"];
                                                 break;
                                             }
                                         }
                                         return retStr == "" ? value : retStr;
                                     },
                                     editRenderer : { // 셀 자체에 드랍다운리스트 출력하고자 할 때
                                            type : "DropDownListRenderer",
                                            list : arrItmStusCode,
                                            keyField   : "codeId", // key 에 해당되는 필드명
                                            valueField : "codeName", // value 에 해당되는 필드명
                                            easyMode : false
                                      }
                                },
                               {dataField : "posItmStockId", visible : false}
                           ];
     //그리드 속성 설정
    var itmGridPros = {
            
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            fixedColumnCount    : 1,            
            showStateColumn     : true,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
    };
    
    posItmDetailGridID = GridCommon.createAUIGrid("#itm_detail_grid_wrap", posItmColumnLayout,'', itmGridPros);  // address list
}



//TODO 미개발 message
function fn_underDevelop(){
    Common.alert('The program is under development.');
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
    });
};

function fn_getStatusCode(grpCode){
    
    if(grpCode == '9'){
        $.ajax({
            type: 'get',
            url : getContextPath() + '/sales/pos/selectStatusCodeList',
            data : {groupCode : grpCode},
            dataType : 'json',
            async : false,
            beforeSend: function (request) {
                 // loading start....
                 Common.showLoader();
             },
             complete: function (data) {
                 // loading end....
                 Common.removeLoader();
             },
             success: function(result) {
                 
                 var tempArr = new Array();
                 
                 for (var idx = 0; idx < result.length; idx++) {
                     tempArr.push(result[idx]); 
                 }
                 arrPosStusCode = tempArr;
                 
            },error: function () {
                Common.alert("Fail to Get Code List....");
            }
            
        });
    }
    
    if(grpCode == '10'){
        $.ajax({
            type: 'get',
            url : getContextPath() + '/sales/pos/selectStatusCodeList',
            data : {groupCode : grpCode},
            dataType : 'json',
            async : false,
            beforeSend: function (request) {
                 // loading start....
                 Common.showLoader();
             },
             complete: function (data) {
                 // loading end....
                 Common.removeLoader();
             },
             success: function(result) {
                 
                 var tempArr = new Array();
                 
                 for (var idx = 0; idx < result.length; idx++) {
                     tempArr.push(result[idx]); 
                 }
                 arrItmStusCode = tempArr; 
                 
            },error: function () {
                Common.alert("Fail to Get Code List....");
            }
            
        });
    }
    
    if(grpCode == '11'){
        $.ajax({
            type: 'get',
            url : getContextPath() + '/sales/pos/selectStatusCodeList',
            data : {groupCode : grpCode},
            dataType : 'json',
            async : false,
            beforeSend: function (request) {
                 // loading start....
                 Common.showLoader();
             },
             complete: function (data) {
                 // loading end....
                 Common.removeLoader();
             },
             success: function(result) {
                 
                 var tempArr = new Array();
                 
                 for (var idx = 0; idx < result.length; idx++) {
                     tempArr.push(result[idx]); 
                 }
                 arrMemStusCode = tempArr; 
                 
            },error: function () {
                Common.alert("Fail to Get Code List....");
            }
            
        });
    }
}


function fn_loadOrderSalesman(memId, memCode, isPop) {

    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

        if(memInfo == null) {
            Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
        }
        else {
            
            if(isPop == 1){
                $('#hiddenSalesmanPopId').val(memInfo.memId);
                $('#salesmanPopCd').val(memInfo.memCode);
               
                $('#salesmanPopCd').removeClass("readonly");    
            }else{
                $('#hiddenSalesmanId').val(memInfo.memId);
                $('#salesmanCd').val(memInfo.memCode);
               
                $('#salesmanCd').removeClass("readonly");
            }
            
          
        }
    });
}


function createAUIGrid(){
    
    
    var posColumnLayout =  [ 
                            {dataField : "posNo", headerText : "POS No.", width : '8%', editable : false}, 
                            {dataField : "posDt", headerText : "Sales Date", width : '8%', editable : false},
                            {dataField : "userName", headerText : "Member ID", width : '8%', editable : false},
                            {dataField : "codeName", headerText : "POS Type", width : '8%', editable : false},
                            {dataField : "codeName1", headerText : "Sales Type", width : '8%', editable : false},
                            {dataField : "taxInvcRefNo", headerText : "Invoice No.", width : '18%', editable : false}, 
                            {dataField : "name", headerText : "Customer Name", width : '8%', editable : false},
                            {dataField : "whLocCode", headerText : "Branch", width : '8%' , style : 'left_style', editable : false},
                            {dataField : "whLocCode", headerText : "Warehouse", width : '8%', editable : false},
                            {dataField : "posTotAmt", headerText : "Total Amount", width : '8%', editable : false},
                            {dataField : "stusId", headerText : "Status", width : '10%',
                                labelFunction : function( rowIndex, columnIndex, value, headerText, item) { 
                                    var retStr = "";
                                    for(var i=0,len=arrPosStusCode.length; i<len; i++) {
                                        if(arrPosStusCode[i]["codeId"] == value) {
                                            retStr = arrPosStusCode[i]["codeName"];
                                            break;
                                        }
                                    }
                                    return retStr == "" ? value : retStr;
                              },
                              editRenderer : {
                                     type : "DropDownListRenderer",
                                     list : arrPosStusCode,
                                     keyField   : "codeId", // key 에 해당되는 필드명
                                     valueField : "codeName", // value 에 해당되는 필드명
                                     easyMode : false
                              }
                            },
                            {dataField : "posId", visible : false},
                            {dataField : "posModuleTypeId", visible : false},
                            {dataField : "posTypeId", visible : false}
                           ];
    
    //그리드 속성 설정
    var gridPros = {
            
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            fixedColumnCount    : 1,            
            showStateColumn     : true,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
    };
    
    posGridID = GridCommon.createAUIGrid("#pos_grid_wrap", posColumnLayout,'', gridPros);  // address list
}

function fn_getPosListAjax(){
    
	  $("#_posModuleTypeId").val($("#cmbPosTypeId").val());
	  $("#_posTypeId").val($("#cmbSalesTypeId").val());
	  
      Common.ajax("GET", "/sales/pos/selectPosJsonList", $("#searchForm").serialize(), function(result) {
        
          AUIGrid.setGridData(posGridID, result);
      });
      
}


function fn_getDateGap(sdate, edate){
    
    var startArr, endArr;
    
    startArr = sdate.split('/');
    endArr = edate.split('/');
    
    var keyStartDate = new Date(startArr[2] , startArr[1] , startArr[0]);
    var keyEndDate = new Date(endArr[2] , endArr[1] , endArr[0]);
    
    var gap = (keyEndDate.getTime() - keyStartDate.getTime())/1000/60/60/24;
    
    console.log("gap : " + gap);
    
    return gap;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Point Of Sales</li>
    <li>POS</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>POS Other income Listing</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="_systemBtn">POS System</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="_reversalBtn">POS Reversal</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="_search"><span class="search"></span>Search</a></p></li>
    </c:if>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_underDevelop()"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form  id="searchForm">
<input type="hidden" id="_posModuleTypeId" name="posModuleTypeId">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody> 
<tr>
    <th scope="row">POS Type</th>
    <td>
    <select class="w100p disabled" id="cmbPosTypeId"  disabled="disabled"></select>
    </td>
    <th scope="row">POS Sales Type</th>
    <td>
    <select class="w100p" id="cmbSalesTypeId" name="posTypeId"></select>
    </td>
    <th scope="row">Status</th>
    <td>
        <select class="w100p" id="cmbStatusTypeId" name="posStatusId" ></select>
    </td>
</tr>
<tr>
    <th scope="row">POS No.</th>
    <td>
    <input type="text" title="" placeholder="POS No." class="w100p"  name="posNo" />
    </td>
    <th scope="row">Sales Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  name="sDate" id="_sDate" value="${bfDay}"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="eDate"  id="_eDate" value="${toDay}"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Member Code</th>
    <td>
        <div class="search_100p"><!-- search_100p start -->
	        <input id="salesmanCd" name="salesmanCd" type="text" title="" placeholder="" class="w100p" />
	        <input id="hiddenSalesmanId" name="salesmanId" type="hidden"  />
	        <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Branch / Warehouse</th>
    <td>
        <select  id="cmbWhBrnchId"  disabled="disabled" class="disabled w100p" name="brnchId"></select>
    </td>
    <td colspan="2" style="padding-left:0"><input type="text" disabled="disabled" id="cmbWhId" class="w100p" ></td>
    <th scope="row">Customer Name</th>
    <td>
    <input type="text" title="" placeholder="Customer Name" class="w100p" name="posCustName" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li><p class="link_btn"><a href="#" onclick="javascript : fn_underDevelop()">POS Receipt</a></p></li>
        </c:if>
    </ul>
    <ul class="btns">
        <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onclick="javascript : fn_underDevelop()">POS Payment Listing</a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onclick="javascript : fn_underDevelop()">POS Raw Data</a></p></li>
        </c:if>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<!-- <ul class="right_btns">
    <li><p class="btn_grid"><a  id="_systemBtn">POS System</a></p></li>
    <li><p class="btn_grid"><a  id="_reversalBtn">POS Reversal</a></p></li>
</ul> -->

<aside class="title_line"><!-- title_line start -->
<h3>Result List</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="pos_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue2 big"><a id="_posStatusBtn">Save</a></p></li>
    </c:if>  
</ul>
<!--item Grid  -->
<div id="_itmDetailGridDiv">
<aside class="title_line"><!-- title_line start -->
<h3>Item List</h3>
</aside><!-- title_line end -->
<article class="grid_wrap"><!-- grid_wrap start --> 
<div id="itm_detail_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue2 big"><a id="_itemStatusBtn">Save</a></p></li>
    </c:if>
</ul>
</div>
</section><!-- search_result end -->
</section><!-- content end -->
<hr />
