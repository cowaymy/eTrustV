<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
    
    var afterServceGridID;
    var beforeServceGridID;
    var orderListGirdID;
    
    var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
            showStateColumn     : true,             
            displayTreeOpen     : false,            
   //         selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
    
    $(document).ready(function() {
        
        //Button Hide
        $("#_memReSelected").css("display" , "none");
        
        //Call Curier List
        doGetCombo("/sales/ccp/selectCurierListJsonList", '', '', '_inputCourierSelect', 'S', '');
        
        //Consignment Init
        fn_consignmentCheckFalse();
        
        //Draw Grid
        createAUIGrid9();
        createAUIGrid10();
        createAUIGrid11();
        
        //Call Ajax (for Grid)
        fn_selectAfterServiceList();
        fn_selectBeforeServiceList(); 
        fn_selectOrderJsonList();
        
        //resize
    //    fn_allGridResize();
        
        //Reselect(Whole)
        $("#_reSelect").click(function() {
            //self.location.href = getContextPath()+"/sales/ccp/insertCcpAgreementSearch.do";
            $("#_ccpResultPopCloseBtn").click();
        });
        
        //Member Search Pop
        $("#_memSearch").click(function() {
            Common.popupDiv('/sales/ccp/searchMemberPop.do' , $('#_searchForm').serializeJSON(), null , true, '_searchDiv');
            
        });
        
        //Reselect(Member)
        $("#_memReSelected").click(function() {

            fn_reSelected();
        });
        
        //confirm click(Member Confirm)
        $("#_memConfirm").click(function() {
            
            
            var inputVal = $("#_inputMemCode").val();
            fn_getMemCodeConfirm(inputVal);
            
        });
        
        
        // New Order Add 
        $("#_newOrderConfirm").click(function() {
            
            var tempInputval = $("#_inputConfirmNewOrder").val();
            fn_getOrderIdResult(tempInputval);
            
        });
        
        // Consignment Change
        $("#_consignment").change(function() {
            
            if($("#_consignment").is(":checked") == true){
                
                fn_consignmentCheckTrue();
                
            }else{
                
                fn_consignmentCheckFalse();
            }
            
        });
        
        $("input[name='inputCourier']").change(function() {
            
            fn_consignmentCheckTrue();
            
        });
        
        //Save
        $("#_saveBtn").click(function() {
            
            //validation
            if(fn_saveValidation() == false){
                   
                return;
                
            }else{
                
                //Disable Value
                $("#_inputProgressR").val($("#_inputProgress").val());
                $("#_inputAgreementStatusR").val($("#_inputAgreementStatus").val());
                
                // Consignment Check
                if($("#_consignment").is(":checked") == true){
                    $("#_consignment").val(true);
                }else{
                    $("#_consignment").val(false);
                }
                
                var data ={};
                var param = AUIGrid.getGridData(orderListGirdID);
                data.add = param;
                data.form = $("#_insForm").serializeJSON();
                
                Common.ajax("POST", "/sales/ccp/insertAgreement.do", data, function(result){
                    
                    //result.msgId
                    $("#_upMsgId").val(result.msgId);
                    console.log("result.msgId(fileName) : " + result.msgId);
                    
                    Common.confirm('<spring:message code="sal.confirm.msg.cntcAgrSuccSaveWantUpload" />', fn_fileUpload , ""); //callback missing, confirm missing
                    if($("#_inputAgreementType").val() == '949'){
                        Common.ajax("GET", "/sales/ccp/sendSuccessEmail.do", result, function(result){
                             console.log(result.message);
                            /* Common.alert(result.message); */
                        });
                    }
                    
                    //disable Proc
                    fn_disableAllField();
                    
                });
            }
        });
        
        //Order Search
        $("#_newOrderSearch").click(function() {
            Common.popupDiv('/sales/ccp/searchOrderNoByEditPop.do' , $('#_searchForm').serializeJSON(), null , true, '_searchEditDiv');
        });
        
    });//Doc Ready End
   
    function fn_disableAllField(){
        
         $("#_saveBtn").css("display" , "none");
         $("#_clearBtn").css("display" , "none");
         $("#_inputMemCode").attr({"disabled" : "disabled"});
         $("#_memConfirm").css("display" , "none");
         $("#_memSearch").css("display" , "none");
         $("#_memReSelected").css("display" , "none");
         $("#_inputDocQty").attr({"disabled" : "disabled"});
         $("#_inputAgreementType").attr({"disabled" : "disabled"});
         $("#_inputPeriodStart").attr({"disabled" : "disabled"});
         $("#_inputPeriodEnd").attr({"disabled" : "disabled"});
         $("#_agreementMsg").attr({"disabled" : "disabled"});
         $("#_agreementAgmRemark").attr({"disabled" : "disabled"});
         $("#_consignment").attr({"disabled" : "disabled"});
         $("input[name='inputCourier']").attr({"disabled" : "disabled"});
         $("#_inputConsignmentNo").attr({"disabled" : "disabled"});
         $("#_inputCourierSelect").attr({"disabled" : "disabled"});
         $("#_inputAgmReq").attr({"disabled" : "disabled"});
         $("#_consignmentReciveDt").attr({"disabled" : "disabled"});
         $("#_inputConfirmNewOrder").attr({"disabled" : "disabled"});
         $("#_inputConfirmNewOrder").val("");
         $("#_newOrderConfirm").css("display" , "none");
         
         AUIGrid.hideColumnByDataField(orderListGirdID, "undefined");
         
    }
    ////////////////////////////////////////////////////////////////////////////////////
  
        function createAUIGrid9() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "asNo",      headerText  : "AS No",
                width       : '10%',               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "asResultNo",        headerText  : "ASR No",
                width       : '10%',               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "code", headerText  : "Status",
                width       : '10%',               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "asReqstDt",  headerText  : "Request Date",
                width       : '10%',               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "asSetlDt",    headerText  : "Settle Date",
                width       : '10%',              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "resnDesc",             headerText  : "Error Code",
                width       : '10%',                               editable    : false,
                style       : 'left_style'
            },{
                dataField   : "resnDesc1",             headerText  : "Error Desc",
                width       : '10%', editable    : false,
                style       : 'left_style'
            },{
                dataField   : "memCode",             headerText  : "CT Code",
                width       : '10%', editable    : false,
                style       : 'left_style'
            },{
                dataField   : "resnDesc2",             headerText  : "Solution",
                width       : '10%',  editable    : false,
                style       : 'left_style'
            },{
                dataField   : "asTotAmt",             headerText  : "Amount",
                width       : '10%', editable    : false,
                style       : 'left_style'
            }];

        //그리드 속성 설정
        
        afterServceGridID = GridCommon.createAUIGrid("grid_afterService_wrap", columnLayout, "", gridPros);
    }
    
        function createAUIGrid10() {
            
            //AUIGrid 칼럼 설정
            var columnLayout = [{
                    dataField   : "no",      headerText  : "BS No",
                    width       : '10%',               editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "bsMonth",        headerText  : "BS Month",
                    width       : '10%',              editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "code", headerText  : "Type",
                    width       : '10%',             editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "code1",  headerText  : "Status",
                    width       : '10%',            editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "no1",    headerText  : "BSR No",
                    width       : '10%',              editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "setlDt",             headerText  : "Settle Date",
                    width       : '20%',                                editable    : false,
                    style       : 'left_style'
                },{
                    dataField   : "memCode",             headerText  : "Cody Code",
                    width       : '10%', editable    : false,
                    style       : 'left_style'
                 },{
                     dataField   : "code3",             headerText  : "Fail Reason",
                     width       : '10%',  editable    : false,
                     style       : 'left_style'
                  },{
                      dataField   : "code2",             headerText  : "Collection Reason",
                      width       : '10%', editable    : false,
                      style       : 'left_style'
                   }];

           
            
            beforeServceGridID = GridCommon.createAUIGrid("grid_beforeService_wrap", columnLayout, "", gridPros);
        }
        
function createAUIGrid11() {
            
            //AUIGrid 칼럼 설정
            var columnLayout = [{
                    dataField   : "salesOrdNo",      headerText  : "Order No",
                    width       : 100,               editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "salesDt",        headerText  : "Order Date",
                    width       : 180,               editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "codeName", headerText  : "App Type",
                    width       : 120,               editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "stkDesc",  headerText  : "Product",
                    width       : 120,               editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "name",    headerText  : "Status",
                    width       : 120,               editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "name1",             headerText  : "Customer Name",
                                                     editable    : false,
                    style       : 'left_style'
                },{
                    dataField   : "salesOrdId",   visible : false
                 },{
                     dataField   : "nric",             headerText  : "NRIC/Company No",
                     editable    : false,
                     style       : 'left_style'
                  },{
                     dataField : "undefined", 
                     headerText : " ", 
                     width : '10%',
                     renderer : {
                              type : "ButtonRenderer", 
                              labelText : "Remove", 
                              onclick : function(rowIndex, columnIndex, value, item) {
                                fn_removeRow(item.salesOrdId);
                            }
                     }
            }];

           
            
            orderListGirdID = GridCommon.createAUIGrid("grid_orderList_wrap", columnLayout, "", gridPros);
        }
    
    // 리스트 조회.
    function fn_selectAfterServiceList(){
        Common.ajax("GET", "/sales/ccp/selectAfterServiceJsonList", $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(afterServceGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectBeforeServiceList(){
        Common.ajax("GET", "/sales/ccp/selectBeforeServiceJsonList", $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(beforeServceGridID, result);
        });
    }
    
    //리스트 조회
    function fn_selectOrderJsonList(){
        Common.ajax("GET", "/sales/ccp/selectOrderJsonList", $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(orderListGirdID, result);
        });
    }
    
    function chgGridTab(tabNm) {
        switch(tabNm) {
            case 'custInfo' :
                AUIGrid.resize(custInfoGridID, 920, 300);
                break;
            case 'memInfo' :
                AUIGrid.resize(memInfoGridID, 920, 300);
                break;
            case 'docInfo' :
                AUIGrid.resize(docGridID, 920, 300);
                if(AUIGrid.getRowCount(docGridID) <= 0) {
                    fn_selectDocumentList();
                }
                break;
            case 'callLogInfo' :
                AUIGrid.resize(callLogGridID, 920, 300);
                if(AUIGrid.getRowCount(callLogGridID) <= 0) {
                    fn_selectCallLogList();
                }
                break;
            case 'payInfo' :
                AUIGrid.resize(payGridID, 920, 300);
                if(AUIGrid.getRowCount(payGridID) <= 0) {
                    fn_selectPaymentList();
                }
                break;
            case 'transInfo' :
                AUIGrid.resize(transGridID, 920, 300);
                if(AUIGrid.getRowCount(transGridID) <= 0) {
                    fn_selectTransList();
                }
                break;
            case 'autoDebitInfo' :
                AUIGrid.resize(autoDebitGridID, 920, 300);
                if(AUIGrid.getRowCount(autoDebitGridID) <= 0) {
                    fn_selectAutoDebitList();
                }
                break;
            case 'discountInfo' :
                AUIGrid.resize(discountGridID, 920, 300);
                if(AUIGrid.getRowCount(discountGridID) <= 0) {
                    fn_selectDiscountList();
                }
                break;
            case 'afterList' :
                AUIGrid.resize(afterServceGridID, 940, 300);
                break;
            case 'beforeList' :
                AUIGrid.resize(beforeServceGridID, 940, 300);
                break;    
                
        };
    }

    
    
    
    function fn_allGridResize(){
        AUIGrid.resize(custInfoGridID, 920, 300);
        AUIGrid.resize(memInfoGridID, 920, 300);
        AUIGrid.resize(docGridID, 920, 300);
        AUIGrid.resize(callLogGridID, 920, 300);
        AUIGrid.resize(payGridID, 920, 300);
        AUIGrid.resize(transGridID, 920, 300);
        AUIGrid.resize(autoDebitGridID, 920, 300);
        AUIGrid.resize(discountGridID, 920, 300);
        AUIGrid.resize(afterServceGridID, 940, 300);
        AUIGrid.resize(beforeServceGridID, 940, 300);
    }
    
    
    function fn_getMemCodeConfirm(inputVal){
        
        $.ajax({
            
            type : "GET",
            url : getContextPath() + "/sales/ccp/getMemCodeConfirm",
            contentType: "application/json;charset=UTF-8",
            crossDomain: true,
            data: {inputMemCode : inputVal},
            dataType: "json",
            success : function (data) {
                
                $("#_inputMemCode").val(data.memCode);
                $("#_hiddenInputMemCode").val(data.memCode);
                $("#_govAgMemId").val(data.memId);
                fn_selected();
            },
            error : function (data) {
                if(data == null){               //error
                    Common.alert('<spring:message code="sal.alert.msg.failToLoadDb" />');
                }else{                            // No data
                    //Common.alert("Unable to find ["+inputVal+"] in system. Please ensure you key in the correct member code.");
                    Common.alert('<spring:message code="sal.alert.msg.unableFindSystem" arguments="'+inputVal+'"/>');
                }
            }
        });
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    function fn_selected(){
        
          $("#_inputMemCode").attr({"readonly" : "readonly" , "class" : "w100 readonly"});
          $("#_memReSelected").css("display" , "");
          $("#_memConfirm").css("display" , "none");
          $("#_memSearch").css("display" , "none");
          $("#_closeMemPop").click();
        
    }
    
    function fn_reSelected(){
        $("#_inputMemCode").val('');
        $("#_hiddenInputMemCode").val('');
        $("#_inputMemCode").attr({"readonly" : false , "class" : ""});
        $("#_memReSelected").css("display" , "none");
        $("#_memConfirm").css("display" , "");
        $("#_memSearch").css("display" , "");
        
    }
    
    
    function fn_getOrderIdResult(ordNum){
        
        $.ajax({
            
            type : "GET",
            url : getContextPath() + "/sales/ccp/getOrderId",
            contentType: "application/json;charset=UTF-8",
            crossDomain: true,
            data: {salesOrderNo : ordNum},
            dataType: "json",
            success : function (data) {
                
                var ordId = data.ordId;
                $("#_addOrdId").val(ordId);
                Common.ajax("GET", "/sales/ccp/selectOrderAddJsonList", $("#_newOrderAddForm").serialize(), function(result){
                    AUIGrid.addRow(orderListGirdID, result, "last");
                });
            },
            error : function (data) {
                if(data == null){               //error
                    Common.alert('<spring:message code="sal.alert.msg.failToLoadDb" />');
                }else{                            // No data
                    Common.alert('<spring:message code="sal.alert.msg.noOrdFoundOrder" />');
                }
                
                
            }
        });
    }
    
    
    //Consignment Check true
    function fn_consignmentCheckTrue(){
        
         //Filed Init
        fn_clearConsignmentField();
        
        if($("input[name='inputCourier']:checked").val() == 'C'){
             
            $("input[name='inputCourier']").attr("disabled", false);
            $("#_inputAgmReq").attr({"disabled" : false , "class" : "w100p"});
            $("#_consignmentReciveDt").attr("disabled", false);
            $("#_inputConsignmentNo").attr("disabled", false);
            $("#_inputCourierSelect").attr({"disabled" : false , "class" : "w100p"});  
                
        }else{
            
            $("input[name='inputCourier']").attr("disabled", false);
            $("#_inputAgmReq").attr({"disabled" : false , "class" : "w100p"});
            $("#_consignmentReciveDt").attr("disabled", false);         
            $("#_inputConsignmentNo").attr("disabled", "disabled");
            $("#_inputCourierSelect").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        }
       
    }
    
  //Consignment Check false
    function fn_consignmentCheckFalse(){
        
         //Filed Init
        fn_clearConsignmentField();
      
        $("input[name='inputCourier']").attr("disabled", "disabled");
        $("input[name='inputCourier']").removeAttr("checked");
        $("#_inputConsignmentNo").attr("disabled", "disabled");
        $("#_inputCourierSelect").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_inputAgmReq").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_consignmentReciveDt").attr("disabled", "disabled");
    }
  
    //Filed Init
    function fn_clearConsignmentField(){
        
        $("#_inputConsignmentNo").val('');
        $("#_inputCourierSelect").val('');
        $("#_inputAgmReq").val('');
        $("#_consignmentReciveDt").val('');
    }  
  
    //Save Validation
    function fn_saveValidation(){
        
        //멤버코드 널체크
        if('' == $("#_inputMemCode").val() || null == $("#_inputMemCode").val()){
            Common.alert('<spring:message code="sal.alert.msg.selectMemCode" />');
            return false;
        }
        
        if('' == $("#_hiddenInputMemCode").val() || null == $("#_hiddenInputMemCode").val()){
            Common.alert('<spring:message code="sal.alert.msg.plzEntConfirmOrSrch" />');
            return false;
        }
        
        //문서 양 숫자 체크
        if($("#_inputDocQty").val() <= -1){
            Common.alert('<spring:message code="sal.alert.msg.plzSelDocQty" />');
            return false;
        }
        
        //Agreement Type 널체크 (뉴/ 리뉴얼)
        if($("#_inputAgreementType").val() <= -1){
            Common.alert('<spring:message code="sal.alert.msg.plzSelAgrType" />');
            return false;
        }
        
        //시작 날짜 널
        if('' == $("#_inputPeriodStart").val() || null == $("#_inputPeriodStart").val()){
            Common.alert('<spring:message code="sal.alert.msg.plzSelArgStartDt" />');
            return false;
        }
        
         //종료 날짜 null 체크
        if('' == $("#_inputPeriodEnd").val() || null == $("#_inputPeriodEnd").val()){
            Common.alert('<spring:message code="sal.alert.msg.plzSelArgEndDt" />');
            return false;
        }
        
        //시작 날짜 종료날짜 비교
        if($("#_inputPeriodStart").val() > $("#_inputPeriodEnd").val()){
            Common.alert('<spring:message code="sal.alert.msg.plzChkArgStartDtCnnotBig" />');
            return false;
        }
        
        //메시지 널체크
        if('' == $("#_agreementMsg").val() || null == $("#_agreementMsg").val()){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyIntheMsg" />');
            return false;
        }
        
        //리마크 널체크
        if('' == $("#_agreementAgmRemark").val() || null == $("#_agreementAgmRemark").val()){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyInTheRem" />');
            return false;
        }
        
        // 수령방법 널체크
        if($("#_consignment").is(":checked") == true){ // 수령방법 체크시  
            
            //Radio Check 
            if( '' == $("input[name='inputCourier']:checked").val() || null == $("input[name='inputCourier']:checked").val()){
                Common.alert('<spring:message code="sal.alert.msg.plzSelectCourierMethod" />');
                return false;
            }
            
            //택배 경우 
            if($("input[name='inputCourier']:checked").val() == 'C'){
                //운송장 번호 널체크 
                if('' == $("#_inputConsignmentNo").val() || null == $("#_inputConsignmentNo").val()){
                    Common.alert('<spring:message code="sal.alert.msg.plzKeyinCourierConsNo" />');
                    return false;
                }
                 
                //운송회사 널체크 // 
                if('' == $("#_inputCourierSelect").val() || null == $("#_inputCourierSelect").val()){
                    Common.alert('<spring:message code="sal.alert.msg.plzSelectCourier" />');
                    return false;   
                }
            }
            
            //AGM Request 널체크  
            if( '' == $("#_inputAgmReq ").val() || null == $("#_inputAgmReq").val()){ 
                Common.alert('<spring:message code="sal.alert.msg.plzSelectAgmReq" />');
                return false;
            }
            
            //Recive Date 널체크
            if('' == $("#_consignmentReciveDt").val() || null == $("#_consignmentReciveDt").val()){
                Common.alert('<spring:message code="sal.alert.msg.plzKeyInTheConsRcvDt" />');
                return false;
            }
        }
        return true;
    }
    
    function  fn_removeRow(ordId){
        var originalOrdId = $("#salesOrderId").val();
        if(originalOrdId == ordId){
            Common.alert('<spring:message code="sal.alert.msg.itmDisaRemvFromList" />');
        }else{
             AUIGrid.removeRow(orderListGirdID, "selectedIndex");  
             AUIGrid.removeSoftRows(orderListGirdID);
             Common.alert('<spring:message code="sal.alert.msg.itmHasbeenRemvFromList" />');
        }
        
    }
    
    function fn_fileUpload(){
        
        var uploadParam = {msgId : $("#_upMsgId").val()};
        
        Common.popupDiv("/sales/ccp/openFileUploadPop.do", uploadParam , null , true , '_uploadDiv');
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.ccpAgrNewSrch" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_ccpResultPopCloseBtn"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<!-- Upload Message Id -->
<input type="hidden" id="_upMsgId"  >
<!-- <aside class="title_line">title_line start
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>New Government Agreement</h2>
</aside>title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="_newOrderAddForm">
    <input id="_addOrdId" name="addOrdId" type="hidden" >
</form>

<form action="#" method="get" id="_searchForm">
<input id="salesOrderId" name="salesOrderId" type="hidden" value="${orderDetail.basicInfo.ordId}">  
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr id="_resultTr" >
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td><input type="text" title="" placeholder="" class=""  value="${salesOrderNo}" readonly="readonly"/><p class="btn_sky"><a href="#" id="_reSelect"><spring:message code="sal.btn.reselect" /></a></p></td>
</tr>
</tbody>
</table><!-- table end -->

<%-- <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end --> --%>

</form>
</section><!-- search_table end -->

<section class="search_result" id="_searchResultSection" ><!-- search_result start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on"><spring:message code="sal.tap.title.ordInfo" /></a></li>
    <li><a href="#" onclick="javascript:chgGridTab('afterList');"><spring:message code="sal.title.text.afterService" /></a></li> 
    <li><a href="#" onclick="javascript:chgGridTab('beforeList');"><spring:message code="sal.title.text.beforeService" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start --><!--###################################  -->

<section class="tap_wrap mt0"><!-- tap_wrap start --> 
<ul class="tap_type1 num4">
    <li><a href="#" class="on"><spring:message code="sal.tap.title.basicInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.hpCody" /></a></li>
    <li><a id="aTabCI" href="#" onClick="javascript:chgGridTab('custInfo');"><spring:message code="sal.title.text.custInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.installInfo" /></a></li>
    <li><a id="aTabMA" href="#"><spring:message code="sal.title.text.maillingInfo" /></a></li>
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
    <li><a href="#"><spring:message code="sal.title.text.paymentChnnl" /></a></li>
</c:if>
    <li><a id="aTabMI" href="#" onClick="javascript:chgGridTab('memInfo');"><spring:message code="sal.title.text.memshipInfo" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('docInfo');"><spring:message code="sal.title.text.docuSubmission" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('callLogInfo');"><spring:message code="sal.title.text.callLog" /></a></li>
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN' && orderDetail.basicInfo.rentChkId == '122'}">
    <li><a href="#"><spring:message code="sal.title.text.quaranteeInfo" /></a></li>
</c:if>
    <li><a href="#" onClick="javascript:chgGridTab('payInfo');"><spring:message code="sal.title.text.paymentListing" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('transInfo');"><spring:message code="sal.title.text.lastSixMonthTrnsaction" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.ordConfiguration" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('autoDebitInfo');"><spring:message code="sal.title.text.autoDebitResult" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.reliefCertificate" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('discountInfo');"><spring:message code="sal.title.text.discount" /></a></li>
</ul>

<!------------------------------------------------------------------------------
    Basic Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/basicInfoIncludeViewLedger.jsp" %>
<!------------------------------------------------------------------------------
    HP / Cody
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/hpCody.jsp" %>
<!------------------------------------------------------------------------------
    Customer Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/custInfo.jsp" %>
<!------------------------------------------------------------------------------
    Installation Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/installInfo.jsp" %>
<!------------------------------------------------------------------------------
    Mailling Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/mailInfo.jsp" %>
<!------------------------------------------------------------------------------
    Payment Channel
------------------------------------------------------------------------------->
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
<%@ include file="/WEB-INF/jsp/sales/order/include/payChannel.jsp" %>
</c:if>
<!------------------------------------------------------------------------------
    Membership Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/membershipInfo.jsp" %>
<!------------------------------------------------------------------------------
    Document Submission
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/docSubmission.jsp" %>
<!------------------------------------------------------------------------------
    Call Log
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/callLog.jsp" %>
<!------------------------------------------------------------------------------
    Quarantee Info
------------------------------------------------------------------------------->
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN' && orderDetail.basicInfo.rentChkId == '122'}">
<%@ include file="/WEB-INF/jsp/sales/order/include/qrntInfo.jsp" %>
</c:if>
<!------------------------------------------------------------------------------
    Payment Listing
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/payList.jsp" %>
<!------------------------------------------------------------------------------
    Last 6 Months Transaction
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/last6Month.jsp" %>
<!------------------------------------------------------------------------------
    Order Configuration
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/orderConfig.jsp" %>
<!------------------------------------------------------------------------------
    Auto Debit Result
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/autoDebit.jsp" %>
<!------------------------------------------------------------------------------
    Relief Certificate
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/rliefCrtfcat.jsp" %>
<!------------------------------------------------------------------------------
    Discount
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/discountList.jsp" %>

    </section><!-- tap_wrap end --> 

</article><!-- tap_area end --><!--###################################  -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_afterService_wrap" style="width:100%; height:380px; margin:0 auto;"></div>

</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
    <article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_beforeService_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
</article>

</section><!-- tap_wrap end -->


<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.agrInformation" /></h3>
</aside><!-- title_line end -->
<form id="_insForm">
<input type="hidden" name="salesOrdId" id="_salesOrdId" value="${orderDetail.basicInfo.ordId}"> 
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:260px" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody> 
<tr>
    <th scope="row"><spring:message code="sal.text.memberCode" /><span class="must">*</span></th>
    <td>
        <input type="text" title="" placeholder="" class="" style="width:100px" id="_inputMemCode" name="inputMemCode"/> 
        <input type="hidden" id="_hiddenInputMemCode" >
        <input type="hidden" id="_govAgMemId" name="govAgMemId">
        <input type="hidden" id="_getMemName" name="getMemName">
        <p class="btn_sky"><a href="#" id="_memConfirm"><spring:message code="sal.text.confirm" /></a></p> 
        <p class="btn_sky"><a href="#" id="_memSearch"><spring:message code="sal.btn.search" /></a></p>
        <p class="btn_sky"><a  id="_memReSelected"><spring:message code="sal.btn.reselect" /></a></p>
    </td>
    <th scope="row"><spring:message code="sal.title.text.docQty" /><span class="must">*</span></th>
    <td>
    <select class="w100p" name="inputDocQty" id="_inputDocQty">
        <option value="-1"><spring:message code="sal.text.quantity" /></option>
        <option value="0">0</option>
        <option value="1">1</option>
        <option value="2">2</option>
        <option value="3">3</option>
        <option value="4">4</option>
        <option value="5">5</option>
        <option value="6">6</option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.agreeType" /><span class="must">*</span></th>
    <td>
    <select class="w100p" name="inputAgreementType" id="_inputAgreementType">
        <option value="-1"><spring:message code="sal.title.type" /></option>
        <option value="949"><spring:message code="sal.title.text.new" /></option>
        <option value="950"><spring:message code="sal.title.text.renewal" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.prgss" /><span class="must">*</span></th>
    <td>
    <input type="hidden" name="inputProgress" id="_inputProgressR">
    <select class="w100p disabled" disabled="disabled"  id="_inputProgress">
        <option value="7" selected="selected"><spring:message code="sal.title.agrSubmission" /></option>
        <option value="8"><spring:message code="sal.title.agrVerifying" /></option>
        <option value="9"><spring:message code="sal.title.argStmpAndConfirm" /></option>
        <option value="10"><spring:message code="sal.title.text.agrFilling" />
</option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.agrStatus" /><span class="must">*</span></th>
    <td>
    <input type="hidden" name="inputAgreementStatus" id="_inputAgreementStatusR">
    <select class="w100p disabled" disabled="disabled"  id="_inputAgreementStatus">
        <option value="1" selected="selected"><spring:message code="sal.btn.active" /></option>
        <option value="4"><spring:message code="sal.combo.text.compl" /></option>
        <option value="10"><spring:message code="sal.combo.text.cancelled" /></option>
        <option value="6"><spring:message code="sal.combo.text.rej" /></option>
    </select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agrPrd" /></th>  
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  name="inputPeriodStart" id="_inputPeriodStart" readonly="readonly"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="inputPeriodEnd" id="_inputPeriodEnd" readonly="readonly"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.msg" /><span class="must">*</span></th>
    <td colspan="5"><textarea cols="20" rows="5" name="agreementMsg" id="_agreementMsg" ></textarea></td> 
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agmRem" /><span class="must">*</span></th>
    <td colspan="5"><textarea cols="20" rows="5" name="agreementAgmRemark" id="_agreementAgmRemark"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.consignInfo" /><label><input type="checkbox"  id="_consignment"  name="consignment"/><span></span></label></h3>
</aside><!-- title_line end --> 

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:195px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr> 
    <th scope="row"><spring:message code="sal.title.text.courierMethod" /></th>
    <td>
    <label><input type="radio" name="inputCourier" value="H"/><span><spring:message code="sal.combo.text.byHand" /></span></label>
    <label><input type="radio" name="inputCourier"  value="C"/><span><spring:message code="sal.text.courier" /></span></label>
    </td>
    <th scope="row"><spring:message code="sal.title.text.courierConsNo" /></th>
    <td><input type="text" title="" placeholder="" class="w100p"  name="inputConsignmentNo" id="_inputConsignmentNo" maxlength="20"/></td>
    <th scope="row"><spring:message code="sal.text.courier" /></th>
    <td>
    <select class="w100p" name="inputCourierSelect" id="_inputCourierSelect"></select> 
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agmRequester" /></th>
    <td>
    <select class="w100p" name="inputAgmReq" id="_inputAgmReq"> 
        <option value=""><spring:message code="sal.title.text.agmRequester" /></option>
        <option value="1"><spring:message code="sal.title.text.hp" /></option>
        <option value="2"><spring:message code="sal.title.text.cody" /></option>
        <option value="1234"><spring:message code="sal.title.text.customer" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.consignRecvDate" /></th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" name="consignmentReciveDt" id="_consignmentReciveDt" readonly="readonly"/></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.newOrder" /></h3>
</aside><!-- title_line end -->
  

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.newOrderNo" /><span class="must">*</span></th>
    <td>
        <input type="text" title="" placeholder="" class="" style="width:100px" id="_inputConfirmNewOrder" name="inputConfirmNewOrder" maxlength="20"/>
        <p class="btn_sky"><a  id="_newOrderConfirm"><spring:message code="sal.title.text.confirmNewOrder" /></a></p>
        <p class="btn_sky"><a  id="_newOrderSearch"><spring:message code="sal.btn.search" /></a></p>  
    </td>
</tr>
</tbody>
</table>

<article class="grid_wrap"><!-- grid_wrap start --> 
<div id="grid_orderList_wrap" style="width:100%; height:200px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="_saveBtn"><spring:message code="sal.btn.save" /></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="_clearBtn"><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</form>
</section><!-- search_result end -->

</section><!-- content end -->

</div>