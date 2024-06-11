<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up{
    text-align: left;
}
</style>
<script type="text/javaScript">
//AUIGrid 그리드 객체
var groupListGridID;
var esmListGridID;
var billGrpHisGridID;
var changeOrderGridID;
var estmHisPopGridID;
var emailAddrPopGridID;
var contPersonPopGridID;
var addOrdPopGridID;
var selectedGridValue;
var gridPros = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,

        // 상태 칼럼 사용
        showStateColumn : false,
        selectionMode : "singleRow"

};
var gridPros2 = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,

        // 상태 칼럼 사용
        showStateColumn : false,
        selectionMode : "multipleRows"
};


// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){

    // 그리드 생성
    //groupListGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    //esmListGridID = GridCommon.createAUIGrid("grid_wrap2", estmColumnLayout,null,gridPros);


    // callcenter 진입시 조회처리.
    if(FormUtil.isNotEmpty($("#orderNo").val())){
        searchList();
	}

});


// AUIGrid 칼럼 설정
var columnLayout = [
    { dataField:"history" ,
        width: 30,
        headerText:" ",
       renderer :
               {
              type : "IconRenderer",
              iconTableRef :  {
                  "default" : "${pageContext.request.contextPath}/resources/images/common/icon_gabage_s.png"// default
              },
              iconWidth : 16,
              iconHeight : 16,
             onclick : function(rowIndex, columnIndex, value, item) {
                 showDetailOrdGrp(item.salesOrdId);
             }
           }
    }, {
        dataField : "isMain",
        headerText : "<spring:message code='pay.head.mainOrder'/>",
        editable : true,
        visible:true,
        renderer :
        {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : 1, // true, false 인 경우가 기본
            unCheckValue : 0,
            checkableFunction  : function(rowIndex, columnIndex, value, isChecked, item, dataField) {

            }

        }
    }, {
        dataField : "custId",
        headerText : "<spring:message code='pay.head.customerId'/>",
        editable : false
    }, {
        dataField : "salesOrdNo",
        headerText : "<spring:message code='pay.head.orderNo'/>",
        editable : false,
    },{
        dataField : "salesDt",
        headerText : "<spring:message code='pay.head.orderDate'/>",
        editable : false,
    },{
        dataField : "code",
        headerText : "<spring:message code='pay.head.status'/>",
        editable : false,
    },{
        dataField : "product",
        headerText : "<spring:message code='pay.head.product'/>",
        editable : false,
        width: 250
    },{
        dataField : "mthRentAmt",
        headerText : "<spring:message code='pay.head.rentalFees'/>",
        editable : false
    }];

//AUIGrid 칼럼 설정
var estmColumnLayout = [
    { dataField:"history" ,
        width: 30,
        headerText:" ",
        colSpan : 2,
       renderer :
               {
              type : "IconRenderer",
              iconTableRef :  {
                  "default" : "${pageContext.request.contextPath}/resources/images/common/btn_close.gif"// default
              },
              iconWidth : 16,
              iconHeight : 16,
             onclick : function(rowIndex, columnIndex, value, item) {

                 if(item.stusCodeId =="44"){
                     showDetailEstmHistory(item.reqId, "C");
                 }
             }
           }
    },
    { dataField:"history" ,
        width: 30,
        headerText:" ",
        colSpan : -1,
        renderer :
               {
              type : "IconRenderer",
              iconTableRef :  {
                  "default" : "${pageContext.request.contextPath}/resources/images/common/btn_check.gif"// default
              },
              iconWidth : 16, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
              iconHeight : 16,
              onclick : function(rowIndex, columnIndex, value, item) {
                  if(item.stusCodeId =="44"){
                      showDetailEstmHistory(item.reqId, "A");
                  }
             }
           }
    }, {
        dataField : "refNo",
        headerText : "<spring:message code='pay.head.refNo'/>",
        editable : false,
    }, {
        dataField : "name",
        headerText : "<spring:message code='pay.head.status'/>",
        editable : false
    }, {
        dataField : "email",
        headerText : "<spring:message code='pay.head.email'/>",
        style : "my-custom-up",
        editable : false,
    },{
        dataField : "emailAdd",
        headerText : "<spring:message code='pay.head.additionalEmail'/>",
        editable : false,
    },{
        dataField : "crtDt",
        headerText : "<spring:message code='pay.head.at'/>",
        editable : false,
    },{
        dataField : "userName",
        headerText : "<spring:message code='pay.head.by'/>",
        editable : false,
    }];

//AUIGrid 칼럼 설정
var billGrpHistoryLayout = [
    {
        dataField : "",
        headerText : "",
        editable : false,
        width : 80,
        renderer :
        {
       type : "IconRenderer",
       iconTableRef :  {
           "default" : "${pageContext.request.contextPath}/resources/images/common/btn_right2.gif"// default
       },
       iconWidth : 20,
       iconHeight : 16,
      onclick : function(rowIndex, columnIndex, value, item) {
          showDetailHistory(item.historyid);
      }
    }
    }, {
        dataField : "codename",
        headerText : "<spring:message code='pay.head.type'/>",
        editable : false,
    }, {
        dataField : "syshisremark",
        headerText : "<spring:message code='pay.head.sysRemark'/>",
        editable : false
    }, {
        dataField : "userhisremark",
        headerText : "<spring:message code='pay.head.userRemark'/>",
        editable : false,
    },{
        dataField : "hiscreated",
        headerText : "<spring:message code='pay.head.at'/>",
        editable : false,
    },{
        dataField : "username",
        headerText : "<spring:message code='pay.head.by'/>",
        editable : false,
    }];

//AUIGrid 칼럼 설정
var changeOrderLayout = [
    {
        dataField : "custBillGrpNo",
        headerText : "<spring:message code='pay.head.grpNo'/>",
        editable : false,
    }, {
        dataField : "salesOrdNo",
        headerText : "<spring:message code='pay.head.orderNo'/>",
        editable : false,
    }, {
        dataField : "salesDt",
        headerText : "<spring:message code='pay.head.orderDate'/>",
        editable : false
    }, {
        dataField : "code",
        headerText : "<spring:message code='pay.head.status'/>",
        editable : false,
    },{
        dataField : "product",
        headerText : "<spring:message code='pay.head.product'/>",
        editable : false,
    },{
        dataField : "mthRentAmt",
        headerText : "<spring:message code='pay.head.rentalFees'/>",
        editable : false,
    }];

//AUIGrid 칼럼 설정
var estmHisPopColumnLayout = [
    {
        dataField : "refNo",
        headerText : "<spring:message code='pay.head.refNo'/>",
        editable : false,
    }, {
        dataField : "name",
        headerText : "<spring:message code='pay.head.status'/>",
        editable : false
    }, {
        dataField : "email",
        headerText : "<spring:message code='pay.head.email'/>",
        style : "my-custom-up",
        editable : false,
    },{
        dataField : "crtDt",
        headerText : "<spring:message code='pay.head.at'/>",
        editable : false,
    },{
        dataField : "<spring:message code='pay.head.userName'/>",
        headerText : "By",
        editable : false,
    }];

//AUIGrid 칼럼 설정
var emailAddrLayout = [
    {
        dataField : "name",
        headerText : "<spring:message code='pay.head.status'/>",
        editable : false,
        width : 80
    }, {
        dataField : "addr",
        headerText : "<spring:message code='pay.head.address'/>",
        editable : false
    }, {
        dataField : "custAddId",
        headerText : "",
        editable : false,
        visible : false
    }];

//AUIGrid 칼럼 설정
var contPersonLayout = [
    {
        dataField : "name",
        headerText : "<spring:message code='pay.head.status'/>",
        editable : false,
    }, {
        dataField : "name1",
        headerText : "<spring:message code='pay.head.name'/>",
        editable : false,
    }, {
        dataField : "nric",
        headerText : "<spring:message code='pay.head.nric'/>",
        editable : false
    }, {
        dataField : "codeName",
        headerText : "<spring:message code='pay.head.race'/>",
        editable : false,
    },{
        dataField : "gender",
        headerText : "<spring:message code='pay.head.gender'/>",
        editable : false,
    },{
        dataField : "telM1",
        headerText : "<spring:message code='pay.head.mobile'/>",
        editable : false,
    },{
        dataField : "telR",
        headerText : "<spring:message code='pay.head.residence'/>",
        editable : false,
    },{
        dataField : "telf",
        headerText : "<spring:message code='pay.head.fax'/>",
        editable : false,
    },{
        dataField : "custCntcId",
        headerText : "<spring:message code='pay.head.custCntcId'/>",
        editable : false,
        visible : false
    }];

//AUIGrid 칼럼 설정
var addOrderLayout = [
    {
        dataField : "isMain",
        headerText : "<spring:message code='pay.head.mainOrder'/>",
        editable : true,
        visible:true,
        renderer :
        {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : 1, // true, false 인 경우가 기본
            unCheckValue : 0,
            checkableFunction  : function(rowIndex, columnIndex, value, isChecked, item, dataField) {

            }
        }
    },{
        dataField : "custBillGrpNo",
        headerText : "<spring:message code='pay.head.grpNo'/>",
        editable : false,
    }, {
        dataField : "salesOrdNo",
        headerText : "<spring:message code='pay.head.orderNo'/>",
        editable : false,
    }, {
        dataField : "salesDt",
        headerText : "<spring:message code='pay.head.orderDate'/>",
        editable : false
    }, {
        dataField : "code",
        headerText : "<spring:message code='pay.head.status'/>",
        editable : false,
    },{
        dataField : "product",
        headerText : "<spring:message code='pay.head.product'/>",
        editable : false,
    },{
        dataField : "mthRentAmt",
        headerText : "<spring:message code='pay.head.rentalFees'/>",
        editable : false,
    },{
        dataField : "salesOrdId",
        headerText : "<spring:message code='pay.head.orderId'/>",
        editable : false,
        visible:false
    }];

    //ajax list 조회.
    function searchList(){

        var now = new Date();
        var year= now.getFullYear();
        var mon = (now.getMonth()+1)>9 ? ''+(now.getMonth()+1) : '0'+(now.getMonth()+1);
        var currentDay = now.getDate()>9 ? ''+now.getDate() : '0'+now.getDate();
        var valid = true;
        var message = "";
        var orderNo = $("#orderNo").val();
        orderNo = $.trim(orderNo);

        if(currentDay >= 31 || currentDay == 1){

            Common.alert("<spring:message code='pay.alert.unable26And1'/>");
            return;

        }else{

            if(orderNo == ""){
                valid = false;
                message = "<spring:message code='pay.alert.orderNumber'/>"
            }

            if(valid){

                Common.ajax("GET","/payment/selectBillGroup.do", {"orderNo":orderNo}, function(result){

                    if(result.data.selectBasicInfo != null){

                        $("#displayVisible").show();
                        $("#orderNo").addClass('readonly');
                        $("#orderNo").prop('readonly', true);
                        $("#custBillId").val(result.data.custBillId);//히든값
                        $("#custBillCustId").val(result.data.selectBasicInfo.custBillCustId);//히든값
                        $("#custBillGrpNo").text(result.data.selectBasicInfo.custBillGrpNo);
                        $("#creator").text(result.data.selectBasicInfo.userName);
                        $("#mainOrder").text(result.data.selectBasicInfo.salesOrdNo);
                        $("#createDate").text(result.data.selectBasicInfo.custBillCrtDt);
                        $("#customerId").text(result.data.selectBasicInfo.custBillCustId+"("+result.data.selectBasicInfo.codeName+")");
                        $("#nric").text(result.data.selectBasicInfo.nric);
                        $("#customerName").text(result.data.selectBasicInfo.name);

                        $("#post").prop('checked', false);//reset
                        $("#sms").prop('checked', false);//reset
                        $("#estm").prop('checked', false);//reset
                        var isPost = result.data.selectBasicInfo.custBillIsPost;
                        var isSms = result.data.selectBasicInfo.custBillIsSms;
                        var isEstm = result.data.selectBasicInfo.custBillIsEstm;

                        if(isPost == 1 && isSms == 1 && isEstm == 1){
                          $("#post").prop('checked', true);
                        }else if(isPost == 1 && isSms == 1 && isEstm == 0){
                          $("#sms").prop('checked', true);
                        }else if(isPost == 1 && isSms == 0 && isEstm == 0){
                          $("#post").prop('checked', true);
                        }else if(isPost == 0 && isSms == 1 && isEstm == 0){
                          $("#sms").prop('checked', true);
                        }else if(isPost == 0 && isSms == 0 && isEstm == 1){
                          $("#estm").prop('checked', true);
                        }else if(isPost == 0 && isSms == 1 && isEstm == 1){
                          $("#estm").prop('checked', true);
                        }else if(isPost == 1 && isSms == 0 && isEstm == 1){
                          $("#estm").prop('checked', true);
                        }else{
                          //$("#sms").prop('checked', false);
                          $("#estm").prop('checked', true);
                          //$("#post").prop('checked', false);
                        }

                        var eInvFlg = result.data.selectBasicInfo.eInvFlg;
                        $("#isEInvoice").prop('checked', false); //reset

                        if(eInvFlg == 1){
                            $("#isEInvoice").prop('checked', true);
                        }
                        else{
                            $("#isEInvoice").prop('checked', false);
                        }

                        $("#remark").text(result.data.selectBasicInfo.custBillRem);

                        if(result.data.selectBasicInfo.custBillEmail != undefined){
                            $("#email").text(result.data.selectBasicInfo.custBillEmail);
                        }else{
                            $("#email").text("");
                        }

                        if(result.data.selectBasicInfo.custBillEmailAdd != undefined){
                            $("#additionalEmail").text(result.data.selectBasicInfo.custBillEmailAdd);
                        }else{
                            $("#additionalEmail").text("");
                        }

                        //Mailling Addres
                        if(result.data.selectMaillingInfo != null){
                            $("#maillingAddr").text(result.data.selectMaillingInfo.addr);
                        }else{
                            $("#maillingAddr").text("");
                        }

                        //ContractInfo
                        $("#contractPerson").text(result.data.selecContractInfo.name2);
                        $("#mobileNumber").text(result.data.selecContractInfo.telM1);
                        $("#officeNumber").text(result.data.selecContractInfo.telO);
                        $("#residenceNumber").text(result.data.selecContractInfo.telR);
                        $("#faxNumber").text(result.data.selecContractInfo.telf);

                        AUIGrid.clearGridData(groupListGridID);
                        AUIGrid.setGridData(groupListGridID, result.data.selectGroupList);
                        AUIGrid.resize(groupListGridID);

                        AUIGrid.clearGridData(esmListGridID);
                        AUIGrid.setGridData(esmListGridID, result.data.selectEstmReqHistory);
                        AUIGrid.resize(esmListGridID);

                        $("#confirm").hide();
                        $("#reSelect").show();

                    }else{
                        $("#displayVisible").hide();
                        $("#orderNo").removeClass('readonly');
                        $("#orderNo").prop('readonly', false);
                        Common.alert("<spring:message code='pay.alert.noBilling'/>");
                    }

                },function(jqXHR, textStatus, errorThrown) {
                    Common.alert("<spring:message code='pay.alert.fail'/>");
                    $("#displayVisible").hide();
                });

            }else{
                Common.alert(message);
                $("#displayVisible").hide();
            }
        }
    }

    function fn_billGrpHistory(){

        var custBillId = $("#custBillId").val();
        Common.ajax("GET","/payment/selectBillGrpHistory.do", {"custBillId":custBillId}, function(result){
            $("#viewHistorytPopup").show();
            AUIGrid.destroy(billGrpHisGridID);
            billGrpHisGridID = GridCommon.createAUIGrid("history_wrap", billGrpHistoryLayout,null,gridPros);
            AUIGrid.setGridData(billGrpHisGridID, result);
        });
    }

    function fn_hisClose() {
        $('#viewHistorytPopup').hide();
        searchList();
    }

    function fn_changeMainOrder(){

        var custBillId = $("#custBillId").val();
        Common.ajax("GET","/payment/selectChangeOrder.do", {"custBillId":custBillId}, function(result){
        	 $("#changeMainOrderPop").show();
            $('#custBillSoId').val(result.data.basicInfo.custBillSoId);
            $('#changePop_grpNo').text(result.data.basicInfo.custBillGrpNo);
            $('#changePop_ordGrp').text(result.data.grpOrder.orderGrp);$('#changePop_ordGrp').css("color","red");
            AUIGrid.destroy(changeOrderGridID);
            changeOrderGridID = GridCommon.createAUIGrid("changeOrderGrid", changeOrderLayout,null,gridPros);
            AUIGrid.setGridData(changeOrderGridID, result.data.billGroupOrderView);

            //Grid 셀 클릭시 이벤트
            AUIGrid.bind(changeOrderGridID, "cellClick", function( event ){
                selectedGridValue = event.rowIndex;
                $("#salesOrdId").val(AUIGrid.getCellValue(changeOrderGridID , event.rowIndex , "salesOrdId"));
                $("#salesOrdNo").val(AUIGrid.getCellValue(changeOrderGridID , event.rowIndex , "salesOrdNo"));
            });
        });
    }

    function fn_changeOrderClose() {
        $('#changeMainOrderPop').hide();
        $('#change_reasonUpd').val("");
        $("#salesOrdNo").val("");
        selectedGridValue = undefined;
        searchList();
    }

    function fn_updRemark(){

        var custBillId = $("#custBillId").val();
        Common.ajax("GET","/payment/selectUpdRemark.do", {"custBillId":custBillId}, function(result){
        	$("#updRemPop").show();
            $('#updRem_grpNo').text(result.data.basicInfo.custBillGrpNo);
            $('#updRem_ordGrp').text(result.data.grpOrder.orderGrp);$('#updRem_ordGrp').css("color","red");
            $('#updRem_remark').text(result.data.basicInfo.custBillRem);
        });
    }

    function fn_saveRemark(){

        var custBillId = $("#custBillId").val();
        var newRem = $("#newRem").val();
        var reasonUpd = $("#reasonUpd").val();
        var message = "";
        var valid = true;

        if($.trim(reasonUpd) == ""){
            valid = false;
            message += "<spring:message code='pay.alert.reasonToUpdate'/>";
        }else{
            if($.trim(reasonUpd).length > 200){
                valid = false;
                message += "<spring:message code='pay.alert.than200Characters'/>";
            }
        }

        if(valid){
            Common.ajax("GET","/payment/saveRemark.do", {"custBillId":custBillId , "remarkNew" : newRem, "reasonUpd" : reasonUpd}, function(result){
                console.log(result);
                Common.alert(result.message);
                $("#newRem").val("");
                $("#reasonUpd").val("");
                fn_updRemark();
            });

        }else{
            Common.alert(message);
        }
    }

    function fn_updRemPopClose() {
        $('#updRemPop').hide();
        $("#newRem").val("");
        $("#reasonUpd").val("");
        searchList();
    }

    function fn_changeBillType(){
        var custBillId = $("#custBillId").val();
        Common.popupDiv('/payment/initChangeBillingTypePop.do', {"custBillId":custBillId, "callPrgm" : "BILLING_GROUP_ADMIN"}, null , true ,'_editDiv3New');
    }

    function fn_changeMaillAddr(){

        var custBillId = $("#custBillId").val();
        Common.ajax("GET","/payment/selectChgMailAddr.do", {"custBillId":custBillId}, function(result){
        	$("#chgMailAddrPop").show();

            $('#changeMail_grpNo').text(result.data.basicInfo.custBillGrpNo);
            $('#changeMail_ordGrp').text(result.data.grpOrder.orderGrp);$('#changeMail_ordGrp').css("color","red");
            if(result.data.mailInfo !=null){
            	$('#changeMail_currAddr').text(result.data.mailInfo.addr);
            }else{
            	$('#changeMail_currAddr').text("");
            }
        });
    }

    function fn_chgContPerson(){

        var custBillId = $("#custBillId").val();
        Common.ajax("GET","/payment/selectChgContPerson.do", {"custBillId":custBillId}, function(result){
        	$("#chgContPerPop").show();

            //BASIC INFO
            //$('#custBillCustId').val(result.data.basicInfo.custBillCustId);
            $('#chgContPer_grpNo').text(result.data.basicInfo.custBillGrpNo);
            $('#chgContPer_ordGrp').text(result.data.grpOrder.orderGrp);$('#chgContPer_ordGrp').css("color","red");

            //CURRENT 계약정보
            $('#curr_contPerson').text( result.data.contractInfo.name2);
            $('#curr_contMobNum').text(result.data.contractInfo.telM1);
            $('#curr_contOffNum').text(result.data.contractInfo.telO);
            $('#curr_resNum').text(result.data.contractInfo.telR);
            $('#curr_faxNum').text(result.data.contractInfo.telf);
        });
    }

    function fn_chgContPerPopClose() {
        $('#chgContPerPop').hide();
        searchList();
    }

    function showDetailHistory(historyId){

        Common.ajax("GET", "/payment/selectDetailHistoryView", {"historyId" : historyId} , function(result) {

        	$("#detailhistoryViewPop").show();
           var typeId = result.data.detailHistoryView.typeId;

           $('#det_typeName').text(result.data.detailHistoryView.codeName);
           $('#det_at').text(result.data.detailHistoryView.histCrtDt);
           $('#det_sysRemark').text(result.data.detailHistoryView.sysHistRem);
           $('#det_by').text(result.data.detailHistoryView.histCrtUserId);
           $('#det_userRemark').val(result.data.detailHistoryView.userHistRem);

           if(typeId == "1042"){

               //Mailing Address
               var descFrom = result.data.mailAddrOldHistorty.addr;
               var descTo = result.data.mailAddrNewHistorty.addr;

               $('#det_descFrom').html(descFrom);
               $('#det_descTo').html(descTo);

           }else if(typeId == "1043"){

               //Contact Person
               var descFrom = "";
               var descTo = "";

                descFrom += "<spring:message code='pay.alert.personDescFrom' arguments='"+result.data.cntcIdOldHistory.code+" ; "+result.data.cntcIdOldHistory.name+
                " ; "+result.data.cntcIdOldHistory.nric+" ; "+result.data.cntcIdOldHistory.codeName+" ; "+result.data.cntcIdOldHistory.telM1+
                " ; "+result.data.cntcIdOldHistory.telO+" ; "+result.data.cntcIdOldHistory.telR+" ; "+result.data.cntcIdOldHistory.telf+"' htmlEscape='false' argumentSeparator=';' />";

                descTo += "<spring:message code='pay.alert.personDescFrom' arguments='"+result.data.cntcIdNewHistory.code+" ; "+result.data.cntcIdNewHistory.name+
                " ; "+result.data.cntcIdNewHistory.nric+" ; "+result.data.cntcIdNewHistory.codeName+" ; "+result.data.cntcIdNewHistory.telM1+
                " ; "+result.data.cntcIdNewHistory.telO+" ; "+result.data.cntcIdNewHistory.telR+" ; "+result.data.cntcIdNewHistory.telf+"' htmlEscape='false' argumentSeparator=';' />";

                $('#det_descFrom').html(descFrom);
                $('#det_descTo').html(descTo);

           }else if(typeId == "1044"){

               //Remark
               var descFrom = "";
               var descTo = "";
               descFrom += result.data.detailHistoryView.remOld;
               descTo += result.data.detailHistoryView.remNw;
               $('#det_descFrom').html(descFrom);
               $('#det_descTo').html(descTo);

           }else if(typeId == "1045"){

               var descFrom = "";
               var descTo = "";

               //Post
               if(result.data.detailHistoryView.isPostOld == "1"){
                   descFrom += "<spring:message code='pay.alert.postYes'/>";

               }else{
                   descFrom += "<spring:message code='pay.alert.postNo'/>";
               }

               //SMS
               if(result.data.detailHistoryView.isSmsOld == "1"){
                   descFrom += "<spring:message code='pay.alert.smsYes'/>";

               }else{
                   descFrom += "<spring:message code='pay.alert.smsNo'/>";
               }

               //E-Statement
               if(result.data.detailHistoryView.isEStateOld == "1"){
                   descFrom += "<spring:message code='pay.alert.estmYes'/>";

               }else{
                   descFrom += "<spring:message code='pay.alert.estmNo'/>";
               }

               //Email
               if(result.data.detailHistoryView.emailOld != undefined){
            	   descFrom += "<spring:message code='pay.alert.emailDesc' arguments='"+result.data.detailHistoryView.emailOld+"' htmlEscape='false'/>";
               }else{
            	   descFrom += "<spring:message code='pay.alert.emailNull'/>";
               }

             //E-Invoice
               if(result.data.detailHistoryView.eInvFlgOld == "1"){
                   descFrom += "<br>E-Invoice : Yes";
               }else{
                   descFrom += "<br>E-Invoice : No";
               }

               //Post
               if(result.data.detailHistoryView.isPostNw == "1"){
                   descTo += "<spring:message code='pay.alert.postYes'/>";

               }else{
                   descTo += "<spring:message code='pay.alert.postNo'/>";
               }

               //SMS
               if(result.data.detailHistoryView.isSmsNw == "1"){
                   descTo += "<spring:message code='pay.alert.smsYes'/>";

               }else{
                   descTo += "<spring:message code='pay.alert.smsNo'/>";
               }

               //E-Statement
               if(result.data.detailHistoryView.isEStateNw == "1"){
                   descTo += "<spring:message code='pay.alert.estmYes'/>";

               }else{
                   descTo += "<spring:message code='pay.alert.estmNo'/>";
               }

               //Email
               if(result.data.detailHistoryView.emailNw != undefined){
            	   descTo += "<spring:message code='pay.alert.emailDesc' arguments='"+result.data.detailHistoryView.emailNw+"' htmlEscape='false'/>";
               }else{
            	   descTo += "<spring:message code='pay.alert.emailNull'/>";
               }

             //E-Invoice
               if(result.data.detailHistoryView.eInvFlgNew == "1"){
                   descTo += "<br>E-Invoice : Yes";
               }else{
                   descTo += "<br>E-Invoice : No";
               }

               $('#det_descFrom').html(descFrom);
               $('#det_descTo').html(descTo);

           }else if(typeId == "1046"){

               //Order Grouping
               var descFrom = "";
               var descTo = "";

               if(result.data.salesOrderMsOld == null ||result.data.salesOrderMsOld == ""){
                   descFrom += "<spring:message code='pay.alert.groupingDescNull'/>";
               }else{
                   descFrom += "<spring:message code='pay.alert.groupingDesc' arguments='"+result.data.salesOrderMsOld.salesOrdNo+" ; "+
                   result.data.salesOrderMsOld.salesDt+" ; "+
                   result.data.salesOrderMsOld.mthRentAmt+" ; "+
                   result.data.salesOrderMsOld.product+"' htmlEscape='false' argumentSeparator=';' />"
               }

               if(result.data.salesOrderMsNw == null || result.data.salesOrderMsNw == ""){
                   descTo += "<spring:message code='pay.alert.groupingDescNull'/>";
               }else{
                   descTo += "<spring:message code='pay.alert.groupingDesc' arguments='"+result.data.salesOrderMsNw.salesOrdNo+" ; "+
                   result.data.salesOrderMsNw.salesDt+" ; "+
                   result.data.salesOrderMsNw.mthRentAmt+" ; "+
                   result.data.salesOrderMsNw.product+"' htmlEscape='false' argumentSeparator=';' />";
               }

               $('#det_descFrom').html(descFrom);
               $('#det_descTo').html(descTo);

           }else if(typeId == "1047"){
               //E-Statement
               var descFrom = "";
               var descTo = "";

               if(result.data.detailHistoryView.isEStateOld == "1"){
                   descFrom += "<spring:message code='pay.alert.estmYes'/>";

               }else{
                   descFrom += "<spring:message code='pay.alert.estmNo'/>";
               }

               //Email
               if(result.data.detailHistoryView.emailOld != undefined){
                   descFrom += "<spring:message code='pay.alert.emailDesc' arguments='"+result.data.detailHistoryView.emailOld+"' htmlEscape='false'/>";
               }else{
                   descFrom += "<spring:message code='pay.alert.emailNull'/>";
               }

               //E-Statement
               if(result.data.detailHistoryView.isEStateNw == "1"){
                   descTo += "<spring:message code='pay.alert.estmYes'/>";

               }else{
                   descTo += "<spring:message code='pay.alert.estmNo'/>";
               }

               //Email
               if(result.data.detailHistoryView.emailNw != undefined){
                   descTo += "<spring:message code='pay.alert.emailDesc' arguments='"+result.data.detailHistoryView.emailNw+"' htmlEscape='false'/>";
               }else{
                   descTo += "<spring:message code='pay.alert.emailNull'/>";
               }

               $('#det_descFrom').html(descFrom);
               $('#det_descTo').html(descTo);

           }else if(typeId == "1048"){

               var descFrom = "";
               var descTo = "";

               if(result.data.salesOrderMsOld == null ||result.data.salesOrderMsOld == ""){
            	   descFrom += "<spring:message code='pay.alert.groupingDescNull'/>";
               }else{
                   descFrom += "<spring:message code='pay.alert.groupingDesc' arguments='"+result.data.salesOrderMsOld.salesOrdNo+" ; "+
                   result.data.salesOrderMsOld.salesDt+" ; "+
                   result.data.salesOrderMsOld.mthRentAmt+" ; "+
                   result.data.salesOrderMsOld.product+"' htmlEscape='false' argumentSeparator=';' />"
               }

               if(result.data.salesOrderMsNw == null || result.data.salesOrderMsNw == ""){
            	   descTo += "<spring:message code='pay.alert.groupingDescNull'/>";
               }else{
                   descTo += "<spring:message code='pay.alert.groupingDesc' arguments='"+result.data.salesOrderMsNw.salesOrdNo+" ; "+
                   result.data.salesOrderMsNw.salesDt+" ; "+
                   result.data.salesOrderMsNw.mthRentAmt+" ; "+
                   result.data.salesOrderMsNw.product+"' htmlEscape='false' argumentSeparator=';' />";
               }

               $('#det_descFrom').html(descFrom);
               $('#det_descTo').html(descTo);
           }
        });
    }

    function fn_selectMailAddr(){

        var custBillCustId = $("#custBillCustId").val();
        var custAddr = $("#custAddr").val();

        Common.ajax("GET","/payment/selectCustMailAddrList.do", {"custBillCustId":custBillCustId, "custAddr" : custAddr}, function(result){
        	$("#selectMaillAddrPop").show();
        	AUIGrid.destroy(emailAddrPopGridID);
        	emailAddrPopGridID = GridCommon.createAUIGrid("selMaillAddrGrid", emailAddrLayout,null,gridPros);
            AUIGrid.setGridData(emailAddrPopGridID, result);

            //Grid 셀 클릭시 이벤트
            AUIGrid.bind(emailAddrPopGridID, "cellClick", function( event ){
                selectedGridValue = event.rowIndex;

                $("#changeMail_newAddr").val(AUIGrid.getCellValue(emailAddrPopGridID , event.rowIndex , "addr"));
                $("#custAddId").val(AUIGrid.getCellValue(emailAddrPopGridID , event.rowIndex , "custAddId"));

                $("#selectMaillAddrPop").hide();
                AUIGrid.destroy(emailAddrPopGridID);
                Common.alert("<spring:message code='pay.alert.newAddrSelected'/>");

            });
        });
    }

    function fn_newAddrSave(){

        var valid = true;
        var message = "";
        var newAddr = $("#changeMail_newAddr").val();
        var reasonUpd = $("#changeMail_resUpd").val();
        var custAddId = $("#custAddId").val();
        var custBillId = $("#custBillId").val();

        if(newAddr == ""){
            valid = false;
            message += "<spring:message code='pay.alert.selectAddr'/>";
        }

        if($.trim(reasonUpd) == ""){
            valid = false;
            message += "<spring:message code='pay.alert.reasonToUpdate'/>";
        }else{
            if ($.trim(reasonUpd).length > 200){
                valid = false;
                message += "<spring:message code='pay.alert.than200Characters'/>";
            }
        }

        if(valid){

            Common.ajax("GET","/payment/saveNewAddr.do", {"custBillId":custBillId, "newAddr" : newAddr, "reasonUpd" : reasonUpd, "custAddId" : custAddId}, function(result){
                console.log(result);
                Common.alert(result.message);
                $("#changeMail_newAddr").val("");
                $("#changeMail_resUpd").val("");
                fn_changeMaillAddr();
            });

        }else{
            Common.alert(message);
        }
    }

    function fn_selectContPerson(){

        var custBillCustId = $("#custBillCustId").val();
        var personKeyword = $("#personKeyword").val();

        Common.ajax("GET","/payment/selectContPersonList.do", {"custBillCustId":custBillCustId, "personKeyword" : personKeyword}, function(result){
        	$("#selectContPersonPop").show();
        	AUIGrid.destroy(contPersonPopGridID);
        	contPersonPopGridID = GridCommon.createAUIGrid("selContPersonGrid", contPersonLayout,null,gridPros);
            AUIGrid.setGridData(contPersonPopGridID, result);

            //Grid 셀 클릭시 이벤트
            AUIGrid.bind(contPersonPopGridID, "cellClick", function( event ){
                selectedGridValue = event.rowIndex;

                $("#custCntcId").val(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "custCntcId"));//히든값
                $("#newContactPerson").text(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "name1"));
                $("#newMobNo").text(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "telM1"));
                $("#newOffNo").text(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "telO"));
                $("#newResNo").text(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "telR"));
                $("#newFaxNo").text(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "telf"));

                $("#selectContPersonPop").hide();
                AUIGrid.destroy(contPersonPopGridID);
                Common.alert("<spring:message code='pay.alert.selectPerson'/>");
            });
        });
    }

    function fn_newContPersonSave(){

        var valid = true;
        var message = "";
        var custCntcId = $("#custCntcId").val();
        var custBillId = $("#custBillId").val();
        var reasonUpd = $("#newContPerReason").val();

        if(custCntcId == ""){
            valid = false;
            message += "<spring:message code='pay.alert.selectContactPerson'/>";
        }

        if($.trim(reasonUpd) == ""){
            valid = false;
            message += "<spring:message code='pay.alert.reasonToUpdate'/>";
        }else{
            if ($.trim(reasonUpd).length > 200){
                valid = false;
                message += "<spring:message code='pay.alert.than200Characters'/>";
            }
        }

        if(valid){
            Common.ajax("GET","/payment/saveNewContPerson.do", {"custBillId":custBillId, "custCntcId" : custCntcId, "reasonUpd" : reasonUpd}, function(result){

                Common.alert(result.message);
                $("#newContactPerson").text("");
                $("#newMobNo").text("");
                $("#newOffNo").text("");
                $("#newResNo").text("");
                $("#newFaxNo").text("");
                $("#newContPerReason").val("");

                fn_chgContPerson();
            });
        }else{
            Common.alert(message);
        }
    }

    function fn_reqNewMail(){
        $("#estmNewReqPop").show();
    }

    function fn_addNewConPerson(){
        var custBillCustId = $("#custBillCustId").val();
        Common.popupDiv('/sales/customer/updateCustomerNewContactPop.do', {"custId":custBillCustId, "callParam" : "billGroup"}, null , true ,'_editDiv3New');
    }

    function fn_reSelect(){
        $("#confirm").show();
        $("#displayVisible").hide();
        $("#reSelect").hide();
        $("#orderNo").val("");
        $("#orderNo").removeClass('readonly');
        $("#orderNo").prop('readonly', false);
        $("#basciInfo").trigger("click");
    }

    function showDetailEstmHistory(val, gubun){

        if(gubun == "A"){
            $("#reqId").val(val);
            $("#btnApprReq").show();
            $("#btnCancelReq").hide();

            Common.ajax("GET","/payment/selectEstmReqHisView.do", {"reqId":val}, function(result){
            	$("#estmDetailHisPop").show();
                $("#apprReq_refNo").text(result.data.estmReqHisView.refNo);
                $("#apprReq_crtDt").text(result.data.estmReqHisView.crtDt);
                $("#apprReq_email").text(result.data.estmReqHisView.email);
                $("#apprReq_creBy").text(result.data.estmReqHisView.crtUserId);
            });

        }else{

            $("#reqId").val(val);
            $("#btnApprReq").hide();
            $("#btnCancelReq").show();

            Common.ajax("GET","/payment/selectEstmReqHisView.do", {"reqId":val}, function(result){
            	$("#estmDetailHisPop").show();
                $("#apprReq_refNo").text(result.data.estmReqHisView.refNo);
                $("#apprReq_crtDt").text(result.data.estmReqHisView.crtDt);
                $("#apprReq_email").text(result.data.estmReqHisView.email);
                $("#apprReq_creBy").text(result.data.estmReqHisView.crtUserId);
            });
        }
    }

    function fn_approveRequest(val){

        var custBillId = $("#custBillId").val();
        var reasonUpd = $("#apprReq_reasonUpd").val();
        var reqId = $("#reqId").val();
        var valid = true;
        var message = "";

        Common.ajax("GET","/payment/selectEStmRequestById.do", {"reqId":reqId}, function(result){
            console.log(result);
            if(result != null){
                var stusId = result.data.estmReqHisView.stusCodeId;

                if(stusId != "44"){
                    valid = false;
                    message += "<spring:message code='pay.alert.estmNoPendingStatus'/>";
                }
	            }else{
	                valid = false;
	                message += "<spring:message code='pay.alert.estmReqValid'/>";
	            }
        });

        if($.trim(reasonUpd) ==""){
            valid = false;
            message += "<spring:message code='pay.alert.reasonToUpdate'/>";

        }else{

            if ($.trim(reasonUpd).length > 200){
                valid = false;
                message += "<spring:message code='pay.alert.than200Characters'/>";
            }
        }

        if(val == "A"){//APPROVE REQUEST

            if(valid){

                Common.ajax("GET","/payment/saveApprRequest.do", {"custBillId":custBillId, "reasonUpd" : reasonUpd, "reqId" : reqId}, function(result){
                    console.log(result);

                        Common.alert(result.message);
                        $("#apprReq_reasonUpd").val("");
                        $("#btnApprReq").hide();

                },function(jqXHR, textStatus, errorThrown) {
                    Common.alert("<spring:message code='pay.alert.estmFailToApprove'/>");
                });

            }else{
                Common.alert(message);
            }

        }else if(val == "C"){//CANCEL REQUEST

            if(valid){
                Common.ajax("GET","/payment/saveCancelRequest.do", {"custBillId":custBillId, "reasonUpd" : reasonUpd, "reqId" : reqId}, function(result){
                    Common.alert(result.message);
                    $("#apprReq_reasonUpd").val("");
                    $("#btnCancelReq").hide();

                },function(jqXHR, textStatus, errorThrown) {
                    Common.alert("<spring:message code='pay.alert.estmFailToCancel'/>");

                });

            }else{
                Common.alert(message);
            }
        }
    }

    function showDetailOrdGrp(salesOrdId){

        $("#salesOrdId").val(salesOrdId);
        var custBillId = $("#custBillId").val();
        var valid = true;
        var message = "";
        $("#btnSave").show();

        Common.ajax("GET","/payment/selectDetailOrdGrp.do", {"custBillId":custBillId, "salesOrdId" : salesOrdId}, function(result){
        	$("#removeOrderPop").show();
            if(result.code =="00"){
                $("#remove_billGroup").text(result.data.basicInfo.custBillGrpNo);
                $("#remove_ordGroup").text(result.data.grpOrder.orderGrp);$('#remove_ordGroup').css("color","red");
                $("#remove_ordNo").text(result.data.billGrpOrdView.salesOrdNo);

                if(result.data.billGrpOrdView.isMain == "1"){
                    $("#remove_isMain").text("Yes");
                }else{
                    $("#remove_isMain").text("No");
                }

                $("#remove_ordDate").text(result.data.billGrpOrdView.salesDt);
                $("#remove_ordStatus").text(result.data.billGrpOrdView.code);
                $("#remove_rentalFees").text(result.data.billGrpOrdView.mthRentAmt);
                $("#remove_product").text(result.data.billGrpOrdView.product);
            }else{
                Common.alert(message);
            }
        });
    }

    function fn_removeOrdGrp() {

        var valid = true;
        var message = "";
        var custBillId = $("#custBillId").val();
        var salesOrdId = $("#salesOrdId").val();
        var reasonUpd = $("#remove_reasonUpd").val();

        if($.trim(reasonUpd) ==""){
            valid = false;
            message += "<spring:message code='pay.alert.reasonToUpdate'/>";

        }else{
            if ($.trim(reasonUpd).length > 200){
                valid = false;
                message += "<spring:message code='pay.alert.than200Characters'/>";
            }
        }

        if(valid){

            Common.confirm("<spring:message code='pay.alert.mainAddress'/>",function (){

                Common.ajax("GET", "/payment/saveRemoveOrder.do", {"custBillId" : custBillId, "reasonUpd":reasonUpd, "salesOrdId":salesOrdId}, function(result) {

                    Common.alert(result.message);

                    $("#remove_ordGroup").text(result.data.grpOrder.orderGrp);$('#remove_ordGroup').css("color","red");
                    $("#btnSave").hide();

                });
            });

        }else{
            Common.alert(message);
        }
    }

    function fn_addNewAddr() {
        var custBillCustId = $("#custBillCustId").val();
        Common.popupDiv('/sales/customer/updateCustomerNewAddressPop.do', {"custId" : custBillCustId,  "callParam" : "billGroup"}, null , true ,'_editDiv2New');
    }

    function fn_addOrder() {

        var custBillId = $("#custBillId").val();

        Common.ajax("GET","/payment/selectAddOrder.do", {"custBillId":custBillId}, function(result){
        	$("#addOrderPop").show();
            $("#addOrd_grpNo").text(result.data.basicInfo.custBillGrpNo);
            $("#addOrd_ordGrp").text(result.data.grpOrder.orderGrp);$('#addOrd_ordGrp').css("color","red");

            AUIGrid.destroy(addOrdPopGridID);
            addOrdPopGridID = GridCommon.createAUIGrid("addOrdGrid", addOrderLayout,null,gridPros2);
            AUIGrid.setGridData(addOrdPopGridID, result.data.orderGrpList);

            //Grid 셀 클릭시 이벤트
            AUIGrid.bind(addOrdPopGridID, "cellClick", function( event ){
                selectedGridValue = event.rowIndex;
                $("#salesOrdNo").val(AUIGrid.getCellValue(addOrdPopGridID , event.rowIndex , "salesOrdNo"));
                $("#salesOrdId").val(AUIGrid.getCellValue(addOrdPopGridID , event.rowIndex , "salesOrdId"));
            });
        });
    }

    function fn_addOrdSave() {
        var valid = true;
        var message = "";
        var custBillId = $("#custBillId").val();
        var reasonUpd = $("#addOrd_reasonUpd").val();
        var selectedItems = AUIGrid.getSelectedItems(addOrdPopGridID);
        var i, rowItem, rowInfoObj, dataField;
        var str = "";
        var str2 = "";

        if(selectedItems.length <= 0) {
            valid = false;
            message += "<spring:message code='pay.alert.selectOneOrder'/>";
        }

        if($.trim(reasonUpd) ==""){
            valid = false;
            message += "<spring:message code='pay.alert.reasonToUpdate'/>";
        }else{
            if ($.trim(reasonUpd).length > 200){
                valid = false;
                message += "<spring:message code='pay.alert.than200Characters'/>";
            }
        }

        if(valid){

            for(i=0; i<selectedItems.length; i++) {
                rowInfoObj = selectedItems[i];
                rowItem = rowInfoObj.item;
                $("#salesOrdNo").val(rowItem.salesOrdNo);
                str += rowItem.salesOrdNo +":";
                $("#salesOrdId").val(rowItem.salesOrdId);
                str2 += rowItem.salesOrdId +":";
            }

            var salesOrdNoArr = str.substring(0, str.length -1);
            var salesOrdIdArr = str2.substring(0, str2.length -1);
            var message2 = "<spring:message code='pay.alert.orderIntoBillingGroup' arguments='"+selectedItems.length+"' htmlEscape='false'/>";

            Common.confirm(message2,function (){

                Common.ajax("GET", "/payment/saveAddOrder.do", {"salesOrdNo" : salesOrdNoArr, "reasonUpd":reasonUpd, "custBillId" : custBillId, "salesOrdId" : salesOrdIdArr}, function(result) {
                    $("#addOrd_reasonUpd").val("");
                    Common.alert(result.message);
                    fn_addOrder();
                });
            });

        }else{
            Common.alert(message);
        }
    }

    function fn_chgMainOrd() {

        var valid = true;
        var message = "";
        var custBillId = $("#custBillId").val();
        var reasonUpd = $("#change_reasonUpd").val();

        if(selectedGridValue == undefined){

            valid = false;
            message += "<spring:message code='pay.alert.selectTargetOrder'/>";

        }

        if($.trim(reasonUpd) ==""){
            valid = false;
            message += "<spring:message code='pay.alert.reasonToUpdate'/>";

        }else{

            if ($.trim(reasonUpd).length > 200){
                valid = false;
                message += "<spring:message code='pay.alert.than200Characters'/>";
            }
        }

        if(valid){

            var salesOrdId = $("#salesOrdId").val();
            var salesOrdNo = $("#salesOrdNo").val();
            var custBillSoId = $("#custBillSoId").val();

            var message2= "<spring:message code='pay.alert.mainOrderGroup' arguments='"+salesOrdNo+"' htmlEscape='false'/>";

            Common.confirm(message2,function (){

                Common.ajax("GET", "/payment/saveChgMainOrd.do", {"salesOrdId" : salesOrdId, "reasonUpd":reasonUpd, "custBillId" : custBillId, "salesOrdNo" : salesOrdNo, "custBillSoId": custBillSoId}, function(result) {
                    Common.alert(result.message);
                    $('#change_reasonUpd').val("");
                });

            });

        }else{
            Common.alert(message);
        }
    }

    function fn_chgMailClose(){
        $("#chgMailAddrPop").hide();
        searchList();
    }

    function fn_removeClose(){
        $("#removeOrderPop").hide();
        $("#remove_reasonUpd").val("");
        searchList();
    }

    function fn_apprRequestClose(){
        $("#estmDetailHisPop").hide();
        $("#apprReq_reasonUpd").val("");
        searchList();
    }

    function fn_custAddrClose(){
        $("#selectMaillAddrPop").hide();
        $("#custAddr").val("");
    }

    function fn_keywordClear(){
        $("#custAddr").val("");
    }

    function fn_contPerPopClose(){
        $("#selectContPersonPop").hide();
        $("#contKeyword").val("");
    }

    function fn_keywordClear2(){
        $("#contKeyword").val("");
    }

    function fn_addOrdPopClose(){
        $("#addOrderPop").hide();
        $("#addOrd_reasonUpd").val("");
        searchList();
    }

</script>
<body>
	<div id="wrap"><!-- wrap start -->
		<section id="content"><!-- content start -->
		    <ul class="path">
		            <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		    </ul>
			<aside class="title_line"><!-- title_line start -->
				<p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
				<h2>Billing Group Mgmt (Admin)</h2>
			</aside><!-- title_line end -->
			<section class="search_table"><!-- search_table start -->
				<form action="#" method="post">
					<table class="type1"><!-- table start -->
						<caption>table</caption>
						<colgroup>
						    <col style="width:190px" />
						    <col style="width:*" />
						</colgroup>
						<tbody>
							<tr>
							    <th scope="row">Order Number</th>
							    <td>
							        <input type="text" name="orderNo" id="orderNo" title="" placeholder="Order Number" class="" value="${ord_No}"/>
							        <p class="btn_sky">
							            <a href="javascript:searchList();" id="confirm"><spring:message code='pay.btn.confirm'/></a>
							        </p>
							        <p class="btn_sky">
							            <a href="javascript:fn_reSelect();" id="reSelect" style="display: none"><spring:message code='pay.btn.reselect'/></a>
							        </p>
							     </td>
							</tr>
						</tbody>
					</table><!-- table end -->
				</form>
			</section><!-- search_table end -->
			<div style="display: none" id="displayVisible">
				<section class="search_result"><!-- search_result start -->
					<section class="tap_wrap"><!-- tap_wrap start -->
						<ul class="tap_type1">
						    <li><a href="#" class="on" id="basciInfo">Basic Info</a></li>
						    <li><a href="#">Mailing Address</a></li>
						    <li><a href="#">Contact Info</a></li>
						</ul>
						<article class="tap_area"><!-- tap_area start -->
							<ul class="right_btns">
							    <li><p class="btn_blue2"><a href="javascript:fn_billGrpHistory();"><spring:message code='pay.btn.viewHistory'/></a></p></li>
							    <li><p class="btn_blue2"><a href="javascript:fn_changeMainOrder();"><spring:message code='pay.btn.changemMinOrder'/></a></p></li>
							    <li><p class="btn_blue2"><a href="javascript:fn_updRemark();"><spring:message code='pay.btn.updateRemark'/></a></p></li>
							    <li><p class="btn_blue2"><a href="javascript:fn_changeBillType();"><spring:message code='pay.btn.ChangeBillingType'/></a></p></li>
							</ul>
							<table class="type1 mt10"><!-- table start -->
								<caption>table</caption>
								<colgroup>
								    <col style="width:160px" />
								    <col style="width:*" />
								    <col style="width:160px" />
								    <col style="width:*" />
								</colgroup>
								<tbody>
									<tr>
									    <th scope="row">Billing Group No</th>
									    <td id="custBillGrpNo">
									    </td>
									    <th scope="row">Creator</th>
									    <td id="creator">
									    </td>
									</tr>
									<tr>
									    <th scope="row">Main Order</th>
									    <td id="mainOrder">
									    </td>
									    <th scope="row">Create Date</th>
									    <td id="createDate">
									    </td>
									</tr>
									<tr>
									    <th scope="row">Customer ID</th>
									    <td id="customerId">
									    </td>
									    <th scope="row">NRIC/Company No</th>
									    <td id="nric">
									    </td>
									</tr>
									<tr>
									    <th scope="row">Customer Name</th>
									    <td colspan="3" id="customerName">
									    </td>
									</tr>
									<tr>
									    <th scope="row">Billing Type</th>
									    <td colspan="3">
										    <label><input type="radio" disabled="disabled" id="post" name="post" value="1"/><span>Post</span></label>
					                        <label><input type="radio" disabled="disabled" id="sms" name="sms" value="2"/><span>SMS</span></label>
					                        <label><input type="radio" disabled="disabled" id="estm" name="estm" value="3"/><span>E-Statement</span></label>
									    </td>
									</tr>
									<tr>
                                       <th scope="row">E-Invoice</th>
                                       <td colspan="3">
                                           <input id="isEInvoice" name="isEInvoice" type="checkbox" disabled="disabled"/>
                                       </td>
                                    </tr>
									<tr>
									    <th scope="row">Email</th>
									    <td id="email">
									    </td>
									    <th scope="row">Additional Email</th>
									    <td id="additionalEmail">
									    </td>
									</tr>
									<tr>
									    <th scope="row">Remark</th>
									    <td colspan="3" id="remark">
									    </td>
									</tr>
								</tbody>
							</table><!-- table end -->
						</article><!-- tap_area end -->
						<article class="tap_area"><!-- tap_area start -->
							<ul class="right_btns">
							    <li><p class="btn_blue2"><a href="javascript:fn_changeMaillAddr();"><spring:message code='pay.btn.changeMailingAddress'/></a></p></li>
							</ul>
							<table class="type1 mt10"><!-- table start -->
								<caption>table</caption>
								<colgroup>
								    <col style="width:160px" />
								    <col style="width:*" />
								</colgroup>
								<tbody>
									<tr>
									    <th scope="row">Mailing Address</th>
									    <td id="maillingAddr">
									    </td>
									</tr>
								</tbody>
							</table><!-- table end -->
						</article><!-- tap_area end -->
						<article class="tap_area"><!-- tap_area start -->
							<ul class="right_btns">
							    <li><p class="btn_blue2"><a href="javascript:fn_chgContPerson();"><spring:message code='pay.btn.changeContactPerson'/></a></p></li>
							</ul>
							<table class="type1 mt10"><!-- table start -->
								<caption>table</caption>
								<colgroup>
								    <col style="width:160px" />
								    <col style="width:*" />
								    <col style="width:160px" />
								    <col style="width:*" />
								</colgroup>
								<tbody>
									<tr>
									    <th scope="row">Contact Person</th>
									    <td colspan="3" id="contractPerson">
									    </td>
									</tr>
									<tr>
									    <th scope="row">Mobile Number</th>
									    <td id="mobileNumber">
									    </td>
									    <th scope="row">Office Number</th>
									    <td id="officeNumber">
									    </td>
									</tr>
									<tr>
									    <th scope="row">Residence Number</th>
									    <td id="residenceNumber">
									    </td>
									    <th scope="row">Fax Number</th>
									    <td id="faxNumber">
									    </td>
									</tr>
								</tbody>
							</table><!-- table end -->
						</article><!-- tap_area end -->
					   </section><!-- tap_wrap end -->
					<%-- <div class="divine_auto mt30"><!-- divine_auto start -->
						<div style="width:50%;">
							<div class="border_box" style="height:350px;"><!-- border_box start -->
								<aside class="title_line"><!-- title_line start -->
								<h3 class="pt0">Order In Group</h3>
								<ul class="right_btns top0">
								    <li><p class="btn_grid"><a href="javascript:fn_addOrder();"><spring:message code='pay.btn.addOrder'/></a></p></li>
								</ul>
								</aside><!-- title_line end -->
								<!-- grid_wrap start -->
								        <article id="grid_wrap" class="grid_wrap"></article>
								<!-- grid_wrap end -->
							</div><!-- border_box end -->
						</div>
						<div style="width:50%;">
							<div class="border_box" style="height:350px;"><!-- border_box start -->
								<aside class="title_line"><!-- title_line start -->
								 <h3 class="pt0">E-Statement Request History</h3>
								</aside><!-- title_line end -->
								<!-- grid_wrap start -->
								        <article id="grid_wrap2" class="grid_wrap"></article>
								<!-- grid_wrap end -->
							</div><!-- border_box end -->
						</div>
					</div> --%><!-- divine_auto end -->
					<form name="myForm" id="myForm">
                            <input type="hidden" name="custBillId" id="custBillId">
                            <input type="hidden" name="custBillCustId" id="custBillCustId">
                            <input type="hidden" name="custAddId" id="custAddId">
                            <input type="hidden" name="custCntcId" id="custCntcId">
                            <input type="hidden" name="custTypeId" id="custTypeId">
                            <input type="hidden" name="reqId" id="reqId">
                            <input type="hidden" name="salesOrdId" id="salesOrdId">
                            <input type="hidden" name="salesOrdNo" id="salesOrdNo">
                            <input type="hidden" name="custBillSoId" id="custBillSoId">
                    </form>
				</section><!-- content end -->
			   </div>
		</section><!-- container end -->
		<hr />
	</div><!-- wrap end -->
	<div id="viewHistorytPopup" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
			<h1>Billing Group - History</h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a href="#" onclick="fn_hisClose();"><spring:message code='sys.btn.close'/></a></p></li>
			</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<article id="history_wrap" class="grid_wrap"><!-- grid_wrap start -->
			</article><!-- grid_wrap end -->
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<div id="changeMainOrderPop" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
			<h1>Billing Group Maintenance - Change Main Order</h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a href="#" onclick="fn_changeOrderClose();"><spring:message code='sys.btn.close'/></a></p></li>
			</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:140px" />
				    <col style="width:*" />
				    <col style="width:180px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Billing Group</th>
					        <td id="changePop_grpNo">
					        </td>
					    <th scope="row">Total Order In Group</th>
					        <td id="changePop_ordGrp">
					        </td>
					</tr>
					<tr>
					    <th scope="row">Available Order</th>
					    <td colspan="3">
					        <article id="changeOrderGrid" class="grid_wrap" style="width:100%"></article>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Reason Update</th>
					    <td colspan="3">
					       <textarea cols="20" rows="5" placeholder="" id="change_reasonUpd"></textarea>
					    </td>
					</tr>
				</tbody>
			</table><!-- table end -->
			<ul class="center_btns">
			    <li><p class="btn_blue2 big"><a href="javascript:fn_chgMainOrd();"><spring:message code='sys.btn.save'/></a></p></li>
			</ul>
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<form action="" id="remarkForm" name="remarkForm">
		<div id="updRemPop" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
			<header class="pop_header"><!-- pop_header start -->
				<h1>Billing Group Maintenance - Remark</h1>
				<ul class="right_opt">
				    <li><p class="btn_blue2"><a href="#" onclick="fn_updRemPopClose();"><spring:message code='sys.btn.close'/></a></p></li>
				</ul>
			</header><!-- pop_header end -->
			<section class="pop_body"><!-- pop_body start -->
				<table class="type1"><!-- table start -->
					<caption>table</caption>
					<colgroup>
					    <col style="width:140px" />
					    <col style="width:*" />
					    <col style="width:180px" />
					    <col style="width:*" />
					</colgroup>
					<tbody>
						<tr>
						    <th scope="row">Billing Group</th>
						    <td id="updRem_grpNo">
						    </td>
						    <th scope="row">Total Order In Group</th>
						    <td id="updRem_ordGrp">
						    </td>
						</tr>
						<tr>
						    <th scope="row">Current Remark</th>
						    <td colspan="3">
						      <textarea cols="20" rows="5" placeholder="" readonly="readonly" class="readonly" id="updRem_remark"></textarea>
						    </td>
						</tr>
						<tr>
						    <th scope="row">New Remark</th>
						    <td colspan="3">
						      <textarea cols="20" rows="5" placeholder="" id="newRem"></textarea>
						    </td>
						</tr>
						<tr>
						    <th scope="row">Reason Update</th>
						    <td colspan="3">
						      <textarea cols="20" rows="5" placeholder="" id="reasonUpd"></textarea>
						    </td>
						</tr>
					</tbody>
				</table><!-- table end -->
				<ul class="center_btns">
				    <li><p class="btn_blue2 big"><a href="javascript:fn_saveRemark();"><spring:message code='sys.btn.save'/></a></p></li>
				</ul>
			</section><!-- pop_body end -->
		</div><!-- popup_wrap end -->
	</form>
	<div id="chgMailAddrPop" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
			<h1>Billing Group Maintenance - Mailing Address</h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a href="#" onclick="fn_chgMailClose();"><spring:message code='sys.btn.close'/></a></p></li>
			</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<ul class="right_btns">
			    <li><p class="btn_blue2"><a href="javascript:fn_addNewAddr();"><spring:message code='pay.btn.addNewAddress'/></a></p></li>
			    <li><p class="btn_blue2"><a href="javascript:fn_selectMailAddr();"><spring:message code='pay.btn.selectMailingAddress'/></a></p></li>
			</ul>
			<table class="type1 mt10"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:140px" />
				    <col style="width:*" />
				    <col style="width:180px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Billing Group</th>
					    <td id="changeMail_grpNo">
					    </td>
					    <th scope="row">Total Order In Group</th>
					    <td id="changeMail_ordGrp">
					    </td>
					</tr>
					<tr>
					    <th scope="row">Current Address</th>
					    <td colspan="3">
					       <textarea cols="20" rows="5" placeholder="" readonly="readonly" class="readonly" id="changeMail_currAddr"></textarea>
					    </td>
					</tr>
					<tr>
					    <th scope="row">New Address</th>
					    <td colspan="3">
					       <textarea cols="20" rows="5" placeholder="" id="changeMail_newAddr" readonly="readonly" class="readonly"></textarea>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Reason Update</th>
					    <td colspan="3">
					       <textarea cols="20" rows="5" placeholder="" id="changeMail_resUpd"></textarea>
					    </td>
					</tr>
				</tbody>
			</table><!-- table end -->
			<ul class="center_btns">
			    <li><p class="btn_blue2 big"><a href="javascript:fn_newAddrSave();"><spring:message code='sys.btn.save'/></a></p></li>
			</ul>
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<div id="chgContPerPop" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
		<h1>Billing Group Maintenance - Contact Person</h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a href="#" onclick="fn_chgContPerPopClose();"><spring:message code='sys.btn.close'/></a></p></li>
			</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<ul class="right_btns">
			    <li><p class="btn_blue2"><a href="javascript:fn_addNewConPerson();"><spring:message code='pay.btn.addNewContact'/></a></p></li>
			    <li><p class="btn_blue2"><a href="javascript:fn_selectContPerson();"><spring:message code='pay.btn.selectContactPerson'/></a></p></li>
			</ul>
			<table class="type1 mt10"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:140px" />
				    <col style="width:*" />
				    <col style="width:180px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
				<tr>
				    <th scope="row">Billing Group</th>
				    <td id="chgContPer_grpNo">
				    </td>
				    <th scope="row">Total Order In Group</th>
				    <td id="chgContPer_ordGrp">
				    </td>
				</tr>
				</tbody>
			</table><!-- table end -->
			<aside class="title_line"><!-- title_line start -->
			     <h2>Current Contact Person</h2>
			 </aside><!-- title_line end -->
			<table class="type1 mt10"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:140px" />
				    <col style="width:*" />
				    <col style="width:180px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Contact Person</th>
					    <td colspan="3" id="curr_contPerson">
					    </td>
					</tr>
					<tr>
					    <th scope="row" >Mobile Number</th>
					    <td id="curr_contMobNum">
					    </td>
					    <th scope="row">Office Number</th>
					    <td id="curr_contOffNum">
					    </td>
					</tr>
					<tr>
					    <th scope="row" >Residence Number</th>
					    <td id="curr_resNum">
					    </td>
					    <th scope="row" >Fax Number</th>
					    <td id="curr_faxNum">
					    </td>
					</tr>
				</tbody>
			</table><!-- table end -->
			<aside class="title_line"><!-- title_line start -->
			     <h2>New Contact Person</h2>
			</aside><!-- title_line end -->
			<table class="type1 mt10"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:140px" />
				    <col style="width:*" />
				    <col style="width:180px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
				<tr>
				    <th scope="row">Contact Person</th>
				    <td colspan="3" id="newContactPerson">
				    </td>
				</tr>
				<tr>
				    <th scope="row">Mobile Number</th>
				    <td id="newMobNo">
				    </td>
				    <th scope="row">Office Number</th>
				    <td id="newOffNo">
				    </td>
				</tr>
				<tr>
				    <th scope="row">Residence Number</th>
				    <td id="newResNo">
				    </td>
				    <th scope="row">Fax Number</th>
				    <td id="newFaxNo">
				    </td>
				</tr>
				<tr>
				    <th scope="row">Reason Update</th>
				    <td colspan="3">
				        <textarea cols="20" rows="5" placeholder="" id="newContPerReason"></textarea>
				    </td>
				</tr>
				</tbody>
			</table><!-- table end -->
			<ul class="center_btns">
			    <li><p class="btn_blue2 big"><a href="javascript:fn_newContPersonSave();"><spring:message code='sys.btn.save'/></a></p></li>
			</ul>
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<div id="detailhistoryViewPop" class="popup_wrap size_mid" style="display: none"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
			<h1>Billing Group - History Details</h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
			</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<table class="type1 mt10"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:100px" />
				    <col style="width:*" />
				    <col style="width:110px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Type</th>
					    <td colspan="" id="det_typeName">
					    </td>
					    <th scope="row">At</th>
					    <td colspan="" id="det_at">11
					    </td>
					</tr>
					<tr>
					    <th scope="row">System Remark</th>
					    <td colspan="" id="det_sysRemark">11
					    </td>
					    <th scope="row">By</th>
					    <td colspan="" id="det_by">11
					    </td>
					</tr>
					<tr>
					    <th scope="row">User Remark </th>
					    <td colspan="3">
					       <textarea cols="20" rows="5" placeholder="" readonly="readonly"  id="det_userRemark"></textarea>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Description (From)</th>
					    <td colspan="" id="det_descFrom" height="150px">
					    </td>
					    <th scope="row">Description (To)</th>
					    <td colspan="" id="det_descTo">
					    </td>
					</tr>
				</tbody>
			</table><!-- table end -->
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<div id="selectMaillAddrPop" class="popup_wrap size_mid" style="display: none"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
			<h1>Customer Address - Customer Address</h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a href="#" onclick="fn_custAddrClose();"><spring:message code='sys.btn.close'/></a></p></li>
			</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<ul class="right_btns">
			    <li><p class="btn_blue"><a href="javascript:fn_selectMailAddr();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
			    <li><p class="btn_blue"><a href="javascript:fn_keywordClear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
			</ul>
			<table class="type1 mt10"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:160px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Address Keyword</th>
					    <td>
					       <input type="text" id="custAddr" name="custAddr" title="" placeholder="Keyword" class="w100p" />
					    </td>
					</tr>
				</tbody>
			</table><!-- table end -->
			<article id="selMaillAddrGrid" class="grid_wrap mt30"><!-- grid_wrap start -->
			</article><!-- grid_wrap end -->
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<div id="selectContPersonPop" class="popup_wrap size_mid" style="display: none"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
			<h1>We Bring Wellness - Customer Contact</h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a href="#" onclick="fn_contPerPopClose();"><spring:message code='sys.btn.close'/></a></p></li>
			</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<ul class="right_btns">
			    <li><p class="btn_blue"><a href="javascript:fn_selectContPerson();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
			    <li><p class="btn_blue"><a href="javascript:fn_keywordClear2();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
			</ul>
			<table class="type1 mt10"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:160px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Contact Keyword</th>
					    <td>
					       <input type="text" id="personKeyword" name="personKeyword" title="" placeholder="Keyword" class="w100p" />
					    </td>
					</tr>
				</tbody>
			</table><!-- table end -->
			<article id="selContPersonGrid" class="grid_wrap mt30"><!-- grid_wrap start -->
			</article><!-- grid_wrap end -->
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<div id="contPersonAddPop" class="popup_wrap" style="display: none"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
		<h1>Billing Group Maintenance - Contact Person</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
		</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<table class="type1 mt10"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:150px" />
				    <col style="width:*" />
				    <col style="width:130px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Initial<span class="must">*</span></th>
					    <td>
						    <select class="w100p" id="cmbInitials" name="cmbInitials">
						    </select>
					    </td>
					    <th scope="row">Gender<span class="must">*</span></th>
					    <td>
						    <label><input type="radio" name="gender" /><span>Male</span></label>
						    <label><input type="radio" name="gender" /><span>Female</span></label>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Name<span class="must">*</span></th>
					    <td>
					       <input type="text" title="" placeholder="Name" class="w100p" />
					    </td>
					    <th scope="row">Race<span class="must">*</span></th>
					    <td>
						    <select id="raceId" name="raceId" class="w100p">
						    </select>
					    </td>
					</tr>
					<tr>
					    <th scope="row">NRIC</th>
					    <td>
					       <input type="text" title="" placeholder="NRIC Number" class="w100p" />
					    </td>
					    <th scope="row">DOB</th>
					    <td>
					       <input type="text" title="Create start Date" placeholder="Date of Brith" class="j_date" />
					    </td>
					</tr>
					<tr>
					    <th scope="row">Tel (Mobile)<span class="must">*</span></th>
					    <td>
					       <input type="text" title="Telephone Number (Mobile)" placeholder="" class="w100p" />
					    </td>
					    <th scope="row">Tel (Office)<span class="must">*</span></th>
					    <td>
					       <input type="text" title="" placeholder="Telephone Number (Office)" class="w100p" />
					    </td>
					</tr>
					<tr>
					    <th scope="row">Tel (Residence)<span class="must">*</span></th>
					    <td>
					       <input type="text" title="" placeholder="Telephone Number (Residence)" class="w100p" />
					    </td>
					    <th scope="row">Tel (Fax)<span class="must">*</span></th>
					    <td>
					       <input type="text" title="" placeholder="Telephone Number (Fax)" class="w100p" />
					    </td>
					</tr>
					<tr>
					    <th scope="row">Department</th>
					    <td>
					       <input type="text" title="" placeholder="Department" class="w100p" />
					    </td>
					    <th scope="row">Job Position</th>
					    <td>
					       <input type="text" title="" placeholder="Job Position" class="w100p" />
					    </td>
					</tr>
					<tr>
					    <th scope="row">Ext No.</th>
					    <td>
					       <input type="text" title="" placeholder="Extension Number" class="w100p" />
					    </td>
					    <th scope="row">Email</th>
					    <td>
					       <input type="text" title="" placeholder="Email" class="w100p" />
					    </td>
					</tr>
				</tbody>
			</table><!-- table end -->
			<ul class="center_btns">
			    <li><p class="btn_blue2 big"><a href="#">Save Contact Person</a></p></li>
			</ul>
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<div id="estmDetailHisPop" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
			<h1>E-Statement - Approve Request</h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a href="" onclick="fn_apprRequestClose();"><spring:message code='sys.btn.close'/></a></p></li>
			</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:140px" />
				    <col style="width:*" />
				    <col style="width:180px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Reference No</th>
					    <td id="apprReq_refNo">
					    </td>
					    <th scope="row">Create Date </th>
					    <td id="apprReq_crtDt">
					    </td>
					</tr>
					<tr>
					    <th scope="row">Email</th>
					    <td id="apprReq_email">
					    </td>
					    <th scope="row">Create By</th>
					    <td id="apprReq_creBy">
					    </td>
					</tr>
					<tr>
					    <th scope="row">Reason Update</th>
					    <td colspan="3">
					       <textarea cols="20" rows="5" placeholder="" id="apprReq_reasonUpd"></textarea>
					    </td>
					</tr>
				</tbody>
			</table><!-- table end -->
			<ul class="center_btns">
			    <li><p class="btn_blue2 big"><a href="javascript:fn_approveRequest('A');" id="btnApprReq"><spring:message code='pay.btn.approveRequest'/></a></p></li>
			    <li><p class="btn_blue2 big"><a href="javascript:fn_approveRequest('C');" id="btnCancelReq"><spring:message code='pay.btn.cancelRequest'/></a></p></li>
			</ul>
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<div id="removeOrderPop" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
			<h1>Billing Group Maintenance - Remove Order From Group</h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a href="#" onclick="fn_removeClose();"><spring:message code='sys.btn.close'/></a></p></li>
			</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:140px" />
				    <col style="width:*" />
				    <col style="width:180px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Billing Group</th>
					    <td id="remove_billGroup">
					    </td>
					    <th scope="row">Total Order In Group</th>
					    <td id="remove_ordGroup">
					    </td>
					</tr>
					<tr>
					    <th scope="row">Order Number</th>
					    <td id="remove_ordNo">
					    </td>
					    <th scope="row">Is Main</th>
					    <td id="remove_isMain">
					    </td>
					</tr>
					<tr>
					    <th scope="row">Order Date</th>
					    <td id="remove_ordDate">
					    </td>
					    <th scope="row">Order Status</th>
					    <td id="remove_ordStatus">
					    </td>
					</tr>
					<tr>
					    <th scope="row">Rental Fees</th>
					    <td id="remove_rentalFees">
					    </td>
					    <th scope="row">Product</th>
					    <td id="remove_product">
					    </td>
					</tr>
					<tr>
					    <th scope="row">Reason Update</th>
					    <td colspan="3">
					       <textarea cols="20" rows="5" placeholder="" id="remove_reasonUpd"></textarea>
					    </td>
					</tr>
				</tbody>
			</table><!-- table end -->
			<ul class="center_btns">
			    <li><p class="btn_blue2 big"><a href="javascript:fn_removeOrdGrp();" id="btnSave"><spring:message code='sys.btn.save'/></a></p></li>
			</ul>
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<div id="addOrderPop" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
		<h1>Billing Group Maintenance - Add Order Into Group</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="" onclick="fn_addOrdPopClose();"><spring:message code='sys.btn.close'/></a></p></li>
		</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:140px" />
				    <col style="width:*" />
				    <col style="width:180px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Billing Group</th>
					    <td id="addOrd_grpNo">
					    </td>
					    <th scope="row">Total Order In Group</th>
					    <td id="addOrd_ordGrp">
					    </td>
					</tr>
					<tr>
					    <th scope="row">Available Order</th>
					    <td colspan="3">
					        <article id="addOrdGrid" class="grid_wrap" style="width:100%"></article>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Reason Update</th>
					    <td colspan="3">
					       <textarea cols="20" rows="5" placeholder="" id="addOrd_reasonUpd"></textarea>
					    </td>
					</tr>
				</tbody>
			</table><!-- table end -->
			<ul class="center_btns">
			    <li><p class="btn_blue2 big"><a href="javascript:fn_addOrdSave();"><spring:message code='sys.btn.save'/></a></p></li>
			</ul>
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
</body>