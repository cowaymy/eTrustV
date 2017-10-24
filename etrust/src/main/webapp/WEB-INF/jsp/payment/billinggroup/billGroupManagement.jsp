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
        showStateColumn : false
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
    groupListGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    esmListGridID = GridCommon.createAUIGrid("grid_wrap2", estmColumnLayout,null,gridPros);
    
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
        headerText : "Main Order",
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
        headerText : "Customer ID",
        editable : false
    }, {
        dataField : "salesOrdNo",
        headerText : "Order No",
        editable : false,
    },{
        dataField : "salesDt",
        headerText : "Order Date",
        editable : false,
    },{
        dataField : "code",
        headerText : "Status",
        editable : false,
    },{
        dataField : "product",
        headerText : "Product",
        editable : false,
        width: 250
    },{
        dataField : "mthRentAmt",
        headerText : "Rental Fees",
        editable : false,
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
        headerText : "Ref No",
        editable : false,
    }, {
        dataField : "name",
        headerText : "Status",
        editable : false
    }, {
        dataField : "email",
        headerText : "Email",
        style : "my-custom-up",
        editable : false,
    },{
        dataField : "",
        headerText : "Additional Email",
        editable : false,
    },{
        dataField : "crtDt",
        headerText : "At",
        editable : false,
    },{
        dataField : "userName",
        headerText : "By",
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
        headerText : "Type",
        editable : false,
    }, {
        dataField : "syshisremark",
        headerText : "System Remark",
        editable : false
    }, {
        dataField : "userhisremark",
        headerText : "User Remark",
        editable : false,
    },{
        dataField : "hiscreated",
        headerText : "At",
        editable : false,
    },{
        dataField : "username",
        headerText : "By",
        editable : false,
    }];
    
//AUIGrid 칼럼 설정
var changeOrderLayout = [ 
    {
        dataField : "custBillGrpNo",
        headerText : "Group No",
        editable : false,
    }, {
        dataField : "salesOrdNo",
        headerText : "Order No",
        editable : false,
    }, {
        dataField : "salesDt",
        headerText : "Order Date",
        editable : false
    }, {
        dataField : "code",
        headerText : "Status",
        editable : false,
    },{
        dataField : "product",
        headerText : "Product",
        editable : false,
    },{
        dataField : "mthRentAmt",
        headerText : "Rental Fees",
        editable : false,
    }];

//AUIGrid 칼럼 설정
var estmHisPopColumnLayout = [ 
    {
        dataField : "refNo",
        headerText : "Ref No",
        editable : false,
    }, {
        dataField : "name",
        headerText : "Status",
        editable : false
    }, {
        dataField : "email",
        headerText : "Email",
        style : "my-custom-up",
        editable : false,
    },{
        dataField : "crtDt",
        headerText : "At",
        editable : false,
    },{
        dataField : "userName",
        headerText : "By",
        editable : false,
    }];
    
//AUIGrid 칼럼 설정 
var emailAddrLayout = [ 
    {
        dataField : "name",
        headerText : "Status",
        editable : false,
        width : 80
    }, {
        dataField : "addr",
        headerText : "Address",
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
        headerText : "Status",
        editable : false,
    }, {
        dataField : "name1",
        headerText : "Name",
        editable : false,
    }, {
        dataField : "nric",
        headerText : "NRIC",
        editable : false
    }, {
        dataField : "codeName",
        headerText : "Race",
        editable : false,
    },{
        dataField : "gender",
        headerText : "Gender",
        editable : false,
    },{
        dataField : "telM1",
        headerText : "Tel(Mobile)",
        editable : false,
    },{
        dataField : "telR",
        headerText : "Tel(Residence)",
        editable : false,
    },{
        dataField : "telf",
        headerText : "Tel(Fax)",
        editable : false,
    },{
        dataField : "custCntcId",
        headerText : "custCntcId",
        editable : false,
        visible : false
    }];
    
//AUIGrid 칼럼 설정
var addOrderLayout = [ 
    {
        dataField : "isMain",
        headerText : "Main Order",
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
        headerText : "Group No",
        editable : false,
    }, {
        dataField : "salesOrdNo",
        headerText : "Order No",
        editable : false,
    }, {
        dataField : "salesDt",
        headerText : "Order Date",
        editable : false
    }, {
        dataField : "code",
        headerText : "Status",
        editable : false,
    },{
        dataField : "product",
        headerText : "Product",
        editable : false,
    },{
        dataField : "mthRentAmt",
        headerText : "Rental Fees",
        editable : false,
    },{
        dataField : "salesOrdId",
        headerText : "Order ID",
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
                
        if(currentDay >= 26 || currentDay == 1){
            
            Common.alert("Unable to perform this between 26 and 1 next month");
            return;
            
        }else{
            
            
            if(orderNo == ""){
                valid = false;
                message = "Please key in the order number."
            }
            
            if(valid){
                
                Common.ajax("GET","/payment/selectBillGroup.do", {"orderNo":orderNo}, function(result){
                    console.log(result);
                    if(result.data.selectBasicInfo != null){
                        
                        $("#displayVisible").show();
                        $("#orderNo").addClass('readonly');
                        $("#custBillId").val(result.data.custBillId);//히든값
                        $("#custBillCustId").val(result.data.selectBasicInfo.custBillCustId);//히든값
                        $("#custBillGrpNo").text(result.data.selectBasicInfo.custBillGrpNo);
                        $("#creator").text(result.data.selectBasicInfo.userName);
                        $("#mainOrder").text(result.data.selectBasicInfo.salesOrdNo);
                        $("#createDate").text(result.data.selectBasicInfo.custBillCrtDt);
                        $("#customerId").text(result.data.selectBasicInfo.custBillCustId+"("+result.data.selectBasicInfo.codeName+")");
                        $("#nric").text(result.data.selectBasicInfo.nric);
                        $("#customerName").text(result.data.selectBasicInfo.name);
                        
                        if(result.data.selectBasicInfo.custBillIsPost == "1"){
                            $("#post").prop('checked', true);
                        }else{
                            $("#post").prop('checked', false);
                        }
                        
                        if(result.data.selectBasicInfo.custBillIsSms == "1"){
                            $("#sms").prop('checked', true);
                        }else{
                            $("#sms").prop('checked', false);
                        }
                        
                        if(result.data.selectBasicInfo.custBillIsEstm == "1"){
                            $("#estm").prop('checked', true);
                        }else{
                            $("#estm").prop('checked', false);
                        }
                        
                        $("#remark").text(result.data.selectBasicInfo.custBillRem);
                        
                        if(result.data.selectBasicInfo.custBillEmail != undefined){
                            $("#email").text(result.data.selectBasicInfo.custBillEmail);
                        }else{
                            $("#email").text("");
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
                        
                        AUIGrid.setGridData(groupListGridID, result.data.selectGroupList);
                        AUIGrid.resize(groupListGridID);
                        
                        AUIGrid.setGridData(esmListGridID, result.data.selectEstmReqHistory);
                        AUIGrid.resize(esmListGridID);
                        
                        $("#confirm").hide();
                        $("#reSelect").show();
                        
                    }else{
                        $("#displayVisible").hide();
                        $("#orderNo").removeClass('readonly');
                        Common.alert("No billing group found for this order.");
                        
                    }
                    
                },function(jqXHR, textStatus, errorThrown) {
                    Common.alert("Fail.");
                    $("#displayVisible").hide();

                });
                
            }else{
                Common.alert(message);
                $("#displayVisible").hide();
            }
            
        }
        
    }
    
    function fn_billGrpHistory(){
        
        AUIGrid.destroy(billGrpHisGridID); 
        $("#viewHistorytPopup").show();
        
        billGrpHisGridID = GridCommon.createAUIGrid("history_wrap", billGrpHistoryLayout,null,gridPros);
        var custBillId = $("#custBillId").val();
        Common.ajax("GET","/payment/selectBillGrpHistory.do", {"custBillId":custBillId}, function(result){
            console.log(result);
            
            AUIGrid.setGridData(billGrpHisGridID, result);
        });
    }
    
    function fn_hisClose() {
        
        $('#viewHistorytPopup').hide();
        searchList();
    }
    
    function fn_changeMainOrder(){
        
        AUIGrid.destroy(changeOrderGridID); 
        $("#changeMainOrderPop").show();
        
        changeOrderGridID = GridCommon.createAUIGrid("changeOrderGrid", changeOrderLayout,null,gridPros);
        var custBillId = $("#custBillId").val();
        Common.ajax("GET","/payment/selectChangeOrder.do", {"custBillId":custBillId}, function(result){
            console.log(result);
            $('#custBillSoId').val(result.data.basicInfo.custBillSoId);
            $('#changePop_grpNo').text(result.data.basicInfo.custBillGrpNo);
            $('#changePop_ordGrp').text(result.data.grpOrder.orderGrp);$('#changePop_ordGrp').css("color","red");
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
        
        $("#updRemPop").show();
        var custBillId = $("#custBillId").val();
        
        Common.ajax("GET","/payment/selectUpdRemark.do", {"custBillId":custBillId}, function(result){
            console.log(result);
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
            message += "* Please key in the reason to update.<br />";
            
        }else{
            
            if($.trim(reasonUpd).length > 200){
                valid = false;
                message += "* Reason to update cannot more than 200 characters.<br />";
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
        
        $("#tab_billType").trigger("click");
        AUIGrid.destroy(estmHisPopGridID); 
        $("#changeBillTypePop").show();
        
        estmHisPopGridID = GridCommon.createAUIGrid("estmHisPopGrid", estmHisPopColumnLayout,null,gridPros);
        var custBillId = $("#custBillId").val();
        Common.ajax("GET","/payment/selectChangeBillType.do", {"custBillId":custBillId}, function(result){
            console.log(result);
            $('#custTypeId').val(result.data.basicInfo.typeId);//히든값
            
            $('#changeBill_grpNo').text(result.data.basicInfo.custBillGrpNo);
            $('#changeBill_ordGrp').text(result.data.grpOrder.orderGrp);$('#changeBill_ordGrp').css("color","red");
            $('#changeBill_remark').text(result.data.basicInfo.custBillRem);
            
            if(result.data.basicInfo.custBillIsPost == "1"){
                $("#changePop_post").prop('checked', true);
            }else{
                $("#changePop_post").prop('checked', false);
            }
            
            if(result.data.basicInfo.custBillIsSms == "1"){
                $("#changePop_sms").prop('checked', true);
            }else{
                $("#changePop_sms").prop('checked', false);
            }
            
            if(result.data.basicInfo.custBillIsEstm == "1"){
                $("#changePop_estm").prop('checked', true);
                $("#changePop_estm").prop('disabled', false);
                $('#changePop_estmVal').val(result.data.basicInfo.custBillEmail);
            }else{
                $("#changePop_estm").prop('checked', false);
                $("#changePop_estm").prop('disabled', true);
                $('#changePop_estmVal').val("");
            }
            
            AUIGrid.setGridData(estmHisPopGridID, result.data.estmReqHistory);
            AUIGrid.resize(estmHisPopGridID,930,300); 
            
        });
    }
    
    function fn_changeMaillAddr(){
        
        $("#chgMailAddrPop").show();
        
        var custBillId = $("#custBillId").val();
        Common.ajax("GET","/payment/selectChgMailAddr.do", {"custBillId":custBillId}, function(result){
            console.log(result);
            
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
        
        $("#chgContPerPop").show();

        var custBillId = $("#custBillId").val();
        Common.ajax("GET","/payment/selectChgContPerson.do", {"custBillId":custBillId}, function(result){
            console.log(result);
            
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
        
        $("#detailhistoryViewPop").show();
        
        Common.ajax("GET", "/payment/selectDetailHistoryView", {"historyId" : historyId} , function(result) {
           console.log(result);
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
               
                descFrom += "Name : ("+result.data.cntcIdOldHistory.code+") " + result.data.cntcIdOldHistory.name + "<br>";
                descFrom += "NRIC : " + result.data.cntcIdOldHistory.nric + " <br>";
                descFrom += "Race : " + result.data.cntcIdOldHistory.codeName + " <br>";
                descFrom += "Tel (M) : " + result.data.cntcIdOldHistory.telM1 + " <br>";
                descFrom += "Tel (O) : " + result.data.cntcIdOldHistory.telO + " <br>";
                descFrom += "Tel (R) : " + result.data.cntcIdOldHistory.telR + " <br>";
                descFrom += "Tel (F) : " + result.data.cntcIdOldHistory.telf + " <br>";
                
                descTo += "Name : ("+result.data.cntcIdNewHistory.code+") " + result.data.cntcIdNewHistory.name +" <br>";
                descTo += "NRIC : " + result.data.cntcIdNewHistory.nric + " <br>";
                descTo += "Race : " + result.data.cntcIdNewHistory.codeName + " <br>";
                descTo += "Tel (M) : " + result.data.cntcIdNewHistory.telM1 + " <br>";
                descTo += "Tel (O) : " + result.data.cntcIdNewHistory.telO + " <br>";
                descTo += "Tel (R) : " + result.data.cntcIdNewHistory.telR + " <br>";
                descTo += "Tel (F) : " + result.data.cntcIdNewHistory.telf + " <br>";
                
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
                   descFrom += "Post : Yes<br>";
                   
               }else{
                   descFrom += "Post : No<br>";
               }
               
               //SMS
               if(result.data.detailHistoryView.isSmsOld == "1"){
                   descFrom += "SMS : Yes<br>";
                   
               }else{
                   descFrom += "SMS : No<br>";
               }
               
               //E-Statement
               if(result.data.detailHistoryView.isEStateOld == "1"){
                   descFrom += "E-Statement : Yes<br>";
                   
               }else{
                   descFrom += "E-Statement : No<br>";
               }
               
               //Email
               descFrom += "Email : " + result.data.detailHistoryView.emailOld;
               
               //Post
               if(result.data.detailHistoryView.isPostNw == "1"){
                   descTo += "Post : Yes<br>";
                   
               }else{
                   descTo += "Post : No<br>";
               }
               
               //SMS
               if(result.data.detailHistoryView.isSmsNw == "1"){
                   descTo += "SMS : Yes<br>";
                   
               }else{
                   descTo += "SMS : No<br>";
               }
               
               //E-Statement
               if(result.data.detailHistoryView.isEStateNw == "1"){
                   descTo += "E-Statement : Yes<br>";
                   
               }else{
                   descTo += "E-Statement : No<br>";
               }
               
               //Email
               descTo += "Email : " + result.data.detailHistoryView.emailNw;
               
               $('#det_descFrom').html(descFrom);
               $('#det_descTo').html(descTo);
               
           }else if(typeId == "1046"){
             
               //Order Grouping
               var descFrom = "";
               var descTo = "";
               
               if(result.data.salesOrderMsOld == null ||result.data.salesOrderMsOld == ""){
                   descFrom += "Order Number : " + "<br>" +
                   "Order Date : "  + "<br>" +
                   "Rental Fees : " + "<br>" +
                   "Product : ";
               }else{
                   descFrom += "Order Number : " + result.data.salesOrderMsOld.salesOrdNo + "<br>" +
                   "Order Date : " + result.data.salesOrderMsOld.salesDt + "<br>" +
                   "Rental Fees : " + result.data.salesOrderMsOld.mthRentAmt + "<br>" +
                   "Product : " + result.data.salesOrderMsOld.product;
               }
               
               if(result.data.salesOrderMsNw == null || result.data.salesOrderMsNw == ""){
                   descTo += "Order Number : "  + "<br>" +
                   "Order Date : " + "<br>" +
                   "Rental Fees : "  + "<br>" +
                   "Product : " ;
               }else{
                   descTo += "Order Number : " + result.data.salesOrderMsNw.salesOrdNo + "<br>" +
                   "Order Date : " + result.data.salesOrderMsNw.salesDt + "<br>" +
                   "Rental Fees : " + result.data.salesOrderMsNw.mthRentAmt + "<br>" +
                   "Product : " + result.data.salesOrderMsNw.product;
               }

               $('#det_descFrom').html(descFrom);
               $('#det_descTo').html(descTo);
               
           }else if(typeId == "1047"){
               //E-Statement
               var descFrom = "";
               var descTo = "";
               
               if(result.data.detailHistoryView.isEStateOld == "1"){
                   descFrom += "E-Statement : Yes<br>";
                   
               }else{
                   descFrom += "E-Statement : No<br>";
               }
               
               //Email
               descFrom += "Email : " + result.data.detailHistoryView.emailOld;
               
               //E-Statement
               if(result.data.detailHistoryView.isEStateNw == "1"){
                   descTo += "E-Statement : Yes<br>";
                   
               }else{
                   descTo += "E-Statement : No<br>";
               }
               
               //Email
               descTo += "Email : " + result.data.detailHistoryView.emailNw;
               
               $('#det_descFrom').html(descFrom);
               $('#det_descTo').html(descTo);
               
           }else if(typeId == "1048"){
               
               var descFrom = "";
               var descTo = "";
               
               if(result.data.salesOrderMsOld == null ||result.data.salesOrderMsOld == ""){
                   descFrom += "Order Number : " + "<br>" +
                   "Order Date : "  + "<br>" +
                   "Rental Fees : " + "<br>" +
                   "Product : ";
               }else{
                   descFrom += "Order Number : " + result.data.salesOrderMsOld.salesOrdNo + "<br>" +
                   "Order Date : " + result.data.salesOrderMsOld.salesDt + "<br>" +
                   "Rental Fees : " + result.data.salesOrderMsOld.mthRentAmt + "<br>" +
                   "Product : " + result.data.salesOrderMsOld.product;
               }
               
               if(result.data.salesOrderMsNw == null || result.data.salesOrderMsNw == ""){
                   descTo += "Order Number : "  + "<br>" +
                   "Order Date : " + "<br>" +
                   "Rental Fees : "  + "<br>" +
                   "Product : " ;
               }else{
                   descTo += "Order Number : " + result.data.salesOrderMsNw.salesOrdNo + "<br>" +
                   "Order Date : " + result.data.salesOrderMsNw.salesDt + "<br>" +
                   "Rental Fees : " + result.data.salesOrderMsNw.mthRentAmt + "<br>" +
                   "Product : " + result.data.salesOrderMsNw.product;
               }
             
               $('#det_descFrom').html(descFrom);
               $('#det_descTo').html(descTo);
               
           }
           
        });
    }
    
    function fn_selectMailAddr(){
        
        AUIGrid.destroy(emailAddrPopGridID); 
        var custBillCustId = $("#custBillCustId").val();
        var custAddr = $("#custAddr").val();
        $("#selectMaillAddrPop").show();
        emailAddrPopGridID = GridCommon.createAUIGrid("selMaillAddrGrid", emailAddrLayout,null,gridPros);
        
        Common.ajax("GET","/payment/selectCustMailAddrList.do", {"custBillCustId":custBillCustId, "custAddr" : custAddr}, function(result){
            console.log(result);
            AUIGrid.setGridData(emailAddrPopGridID, result);
            
            //Grid 셀 클릭시 이벤트
            AUIGrid.bind(emailAddrPopGridID, "cellClick", function( event ){
                selectedGridValue = event.rowIndex;
                
                $("#changeMail_newAddr").val(AUIGrid.getCellValue(emailAddrPopGridID , event.rowIndex , "addr"));
                $("#custAddId").val(AUIGrid.getCellValue(emailAddrPopGridID , event.rowIndex , "custAddId"));
                
                $("#selectMaillAddrPop").hide();
                AUIGrid.destroy(emailAddrPopGridID);
                Common.alert("New address selected.<br/>Click save to confirm change address.");

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
            message += "* Please select the address.<br />";
        }
        
        if($.trim(reasonUpd) == ""){
            valid = false;
            message += "* Please key in the reason to update.<br />";
        }else{
            if ($.trim(reasonUpd).length > 200){
                valid = false;
                message += "* Reason to update cannot more than 200 characters.<br />";
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
        
        AUIGrid.destroy(contPersonPopGridID); 
        var custBillCustId = $("#custBillCustId").val();
        var personKeyword = $("#personKeyword").val();
        $("#selectContPersonPop").show();
        contPersonPopGridID = GridCommon.createAUIGrid("selContPersonGrid", contPersonLayout,null,gridPros);
        
        Common.ajax("GET","/payment/selectContPersonList.do", {"custBillCustId":custBillCustId, "personKeyword" : personKeyword}, function(result){
            console.log(result);
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
                Common.alert("New contact person selected.<br />Click save to confirm change contact person.");

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
            message += "* Please select the contact person.<br />";
        }
        
        if($.trim(reasonUpd) == ""){
            valid = false;
            message += "* Please key in the reason to update.<br />";
        }else{
            if ($.trim(reasonUpd).length > 200){
                valid = false;
                message += "* Reason to update cannot more than 200 characters.<br />";
                
            }
        }
        
        
        if(valid){
            Common.ajax("GET","/payment/saveNewContPerson.do", {"custBillId":custBillId, "custCntcId" : custCntcId, "reasonUpd" : reasonUpd}, function(result){
                console.log(result);
                
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
    
    function fn_newReqSave(){
        var reqEmail = $("#newReqEmail").val();
        var reasonUpd = $("#newReqReason").val();
        var custBillId = $("#custBillId").val();
        var valid = true;
        var message = "";
        
        if($.trim(reqEmail) == ""){
            
            valid = false;
            message += "* Please key in the email address.<br />";
            
        }else{

            if(FormUtil.checkEmail($.trim(reqEmail)) == true){
                valid = false;
                message += "* The email is invalid.<br />"; 
             }
        }
        
        if($.trim(reasonUpd) ==""){
            
            valid = false;
            message += "* Please key in the reason to update.<br />";
        }else{
            
            if ($.trim(reasonUpd).length > 200){
                valid = false;
                message += "* Reason to update cannot more than 200 characters.<br />";
            }
            
        }
        
        if(valid){
            
            Common.ajax("GET","/payment/saveNewReq.do", {"custBillId":custBillId, "reasonUpd" : reasonUpd, "reqEmail" : reqEmail}, function(result){
                console.log(result);
                $("#newReqEmail").val("");
                $("#newReqReason").val("");
                Common.alert(result.message);
            });
            
        }else{
            Common.alert(message);
        }
    }
    
    function fn_estmReqPopClose(){
        fn_changeBillType();
    }
    
    function fn_changeBillSave(){
        
        var custTypeId = $('#custTypeId').val();
        var custBillEmail = $('#changePop_estmVal').val();
        var reasonUpd = $("#changePop_Reason").val();
        var custBillId = $("#custBillId").val();
        
        if($("#changePop_post").is(":checked")){
            $("#changePop_post").val(1);
        }else{
            $("#changePop_post").val(0);
        }
        
        if($("#changePop_sms").is(":checked")){
            $("#changePop_sms").val(1);
        }else{
            $("#changePop_sms").val(0);
        }
        
        if($("#changePop_estm").is(":checked")){
            $("#changePop_estm").val(1);
        }else{
            $("#changePop_estm").val(0);
        }
        
        var valid = true;
        var message = "";
        
        if($("#changePop_post").is(":checked") == false && $("#changePop_sms").is(":checked") == false && $("#changePop_estm").is(":checked") == false ){
            
            valid = false;
            message += "* Please select at least one billing type.<br />";
        }
        
        if($("#changePop_sms").is(":checked") && custTypeId == "965"){
            
            valid = false;
            message += "* SMS is not allow for company type customer.<br />";
        }
        
        if($.trim(reasonUpd) ==""){
            
            valid = false;
            message += "* Please key in the reason to update.<br />";
            
        }else{
            
            if ($.trim(reasonUpd).length > 200){
                
                valid = false;
                message += "* Reason to update cannot more than 200 characters.<br />";
            }
        }
        
        if(valid){
            
            var post = $("#changePop_post").val();
            var sms = $("#changePop_sms").val();
            var estm = $("#changePop_estm").val();
            
            Common.ajax("GET","/payment/saveChangeBillType.do", {"custBillId":custBillId, "reasonUpd" : reasonUpd, "post" : post, "sms" : sms, "estm" : estm, "custBillEmail" :custBillEmail}, function(result){
                console.log(result);
                
                Common.alert(result.message);
                var reasonUpd = $("#changePop_Reason").val("");
                
            });
            
        }else{
            Common.alert(message);
        }
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
    }
    
    function showDetailEstmHistory(val, gubun){
        
        if(gubun == "A"){
            $("#reqId").val(val);
            $("#btnApprReq").show();
            $("#btnCancelReq").hide();
            $("#estmDetailHisPop").show();
            
            Common.ajax("GET","/payment/selectEstmReqHisView.do", {"reqId":val}, function(result){
                console.log(result);
                
                $("#apprReq_refNo").text(result.data.estmReqHisView.refNo);
                $("#apprReq_crtDt").text(result.data.estmReqHisView.crtDt);
                $("#apprReq_email").text(result.data.estmReqHisView.email);
                $("#apprReq_creBy").text(result.data.estmReqHisView.crtUserId);
                
            });
            
        }else{
            
            $("#reqId").val(val);
            $("#btnApprReq").hide();
            $("#btnCancelReq").show();
            $("#estmDetailHisPop").show();
            
            Common.ajax("GET","/payment/selectEstmReqHisView.do", {"reqId":val}, function(result){
                console.log(result);
                
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
                    message += "* This E-Statement request is no longer in pending status.<br />";
                }
            }else{
                valid = false;
                message += "* This E-Statement request is no longer valid.<br />";
            }
            
        });
        
        if($.trim(reasonUpd) ==""){
            valid = false;
            message += "* Please key in the reason to update.<br />";
            
        }else{
            
            if ($.trim(reasonUpd).length > 200){
                valid = false;
                message += "* Reason to update cannot more than 200 characters.<br />";
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
                    Common.alert("Failed to approve this E-Statement request. Please try again later.");

                });
                
            }else{
                Common.alert(message);
            }
            
        }else if(val == "C"){//CANCEL REQUEST
            
            if(valid){
                
                Common.ajax("GET","/payment/saveCancelRequest.do", {"custBillId":custBillId, "reasonUpd" : reasonUpd, "reqId" : reqId}, function(result){
                    console.log(result);

                        Common.alert(result.message);
                        $("#apprReq_reasonUpd").val("");
                        $("#btnCancelReq").hide();
                    
                    
                },function(jqXHR, textStatus, errorThrown) {
                    Common.alert("Failed to cancel this E-Statement request. Please try again later.");

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
        
        $("#removeOrderPop").show();
        $("#btnSave").show();
        
        Common.ajax("GET","/payment/selectDetailOrdGrp.do", {"custBillId":custBillId, "salesOrdId" : salesOrdId}, function(result){
            console.log(result);
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
            message += "* Please key in the reason to update.<br />";
            
        }else{
            
            if ($.trim(reasonUpd).length > 200){
                valid = false;
                message += "* Reason to update cannot more than 200 characters.<br />";
            }
        }
        
        if(valid){
            
            Common.confirm('Are you sure want to set this address as main address ?',function (){
                
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
        
        AUIGrid.destroy(addOrdPopGridID); 
        $("#addOrderPop").show();
        var custBillId = $("#custBillId").val();
        addOrdPopGridID = GridCommon.createAUIGrid("addOrdGrid", addOrderLayout,null,gridPros2);
        
        Common.ajax("GET","/payment/selectAddOrder.do", {"custBillId":custBillId}, function(result){
            console.log(result);
            $("#addOrd_grpNo").text(result.data.basicInfo.custBillGrpNo);
            $("#addOrd_ordGrp").text(result.data.grpOrder.orderGrp);$('#addOrd_ordGrp').css("color","red");
            
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
            message += "* Please select at least one order.<br />";
        }
        
        if($.trim(reasonUpd) ==""){
            valid = false;
            message += "* Please key in the reason to update.<br />";
            
        }else{
            
            if ($.trim(reasonUpd).length > 200){
                valid = false;
                message += "* Reason to update cannot more than 200 characters.<br />";
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
            var message2 = "There are " + selectedItems.length + " order(s) selected.<br />" +
            "Are you sure want to add the order(s) into billing group ?";
            
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
            message += "* Please select the target order.<br />";
            
        }
        
        if($.trim(reasonUpd) ==""){
            valid = false;
            message += "* Please key in the reason to update.<br />";
            
        }else{
            
            if ($.trim(reasonUpd).length > 200){
                valid = false;
                message += "* Reason to update cannot more than 200 characters.<br />";
            }
        }
        
        if(valid){
            
            var salesOrdId = $("#salesOrdId").val();
            var salesOrdNo = $("#salesOrdNo").val();
            var custBillSoId = $("#custBillSoId").val();
            
            var message2= "You have select order [" +salesOrdNo +"].<br />"  + "Are you sure want to set this order as the main order of group ?";
            
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
    
    function fn_chgBillClose(){
        $("#changeBillTypePop").hide();
        $("#changePop_Reason").val("");
        searchList();
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
		            <li>Payment</li>
		            <li>Billing Group</li>
		            <li>Billing Group Mgmt</li>
		    </ul>
			<aside class="title_line"><!-- title_line start -->
				<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
				<h2>Billing Group Mgmt</h2>
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
							        <input type="text" name="orderNo" id="orderNo" title="" placeholder="Order Number" class="" />
							        <p class="btn_sky">
							            <a href="javascript:searchList();" id="confirm">Confirm</a>
							        </p>
							        <p class="btn_sky">
							            <a href="javascript:fn_reSelect();" id="reSelect" style="display: none">Reselect</a>
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
							    <li><p class="btn_blue2"><a href="javascript:fn_billGrpHistory();">View History</a></p></li>
							    <li><p class="btn_blue2"><a href="javascript:fn_changeMainOrder();">Change Main Order</a></p></li>
							    <li><p class="btn_blue2"><a href="javascript:fn_updRemark();">Update Remark</a></p></li>
							    <li><p class="btn_blue2"><a href="javascript:fn_changeBillType();">Change Billing Type</a></p></li>
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
									    <label><input type="checkbox" disabled="disabled" id="post" name="post"/><span>Post</span></label>
									    <label><input type="checkbox" disabled="disabled" id="sms" name="sms"/><span>SMS</span></label>
									    <label><input type="checkbox" disabled="disabled" id="estm" name="estm"/><span>E-Statement</span></label>
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
							    <li><p class="btn_blue2"><a href="javascript:fn_changeMaillAddr();">Change Mailing Address</a></p></li>
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
							    <li><p class="btn_blue2"><a href="javascript:fn_chgContPerson();">Change Contact Person</a></p></li>
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
					<div class="divine_auto mt30"><!-- divine_auto start -->
						<div style="width:50%;">
							<div class="border_box" style="height:350px;"><!-- border_box start -->
								<aside class="title_line"><!-- title_line start -->
								<h3 class="pt0">Order In Group</h3>
								<ul class="right_btns top0">
								    <li><p class="btn_grid"><a href="javascript:fn_addOrder();"><span class="search"></span>Add Order</a></p></li>
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
					</div><!-- divine_auto end -->
				</section><!-- content end -->
			   </div>       
		</section><!-- container end -->
		<hr />
	</div><!-- wrap end -->
	<div id="viewHistorytPopup" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
			<h1>Billing Group - History</h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a href="#" onclick="fn_hisClose();">CLOSE</a></p></li>
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
			    <li><p class="btn_blue2"><a href="#" onclick="fn_changeOrderClose();">CLOSE</a></p></li>
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
			    <li><p class="btn_blue2 big"><a href="javascript:fn_chgMainOrd();">SAVE</a></p></li>
			</ul>
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<form action="" id="remarkForm" name="remarkForm">
		<div id="updRemPop" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
			<header class="pop_header"><!-- pop_header start -->
				<h1>Billing Group Maintenance - Remark</h1>
				<ul class="right_opt">
				    <li><p class="btn_blue2"><a href="#" onclick="fn_updRemPopClose();">CLOSE</a></p></li>
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
				    <li><p class="btn_blue2 big"><a href="javascript:fn_saveRemark();">SAVE</a></p></li>
				</ul>
			</section><!-- pop_body end -->
		</div><!-- popup_wrap end -->
	</form>
	<div id="changeBillTypePop" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
			<h1>Billing Group Maintenance - Billing Type</h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a href="#" onclick="fn_chgBillClose();">CLOSE</a></p></li>
			</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<section class="tap_wrap"><!-- tap_wrap start -->
				<ul class="tap_type1">
				    <li><a href="#" class="on" id="tab_billType" >Billing Type Info</a></li>
				    <li><a href="#" id="tab_estmHis">E-Statement History</a></li>
				</ul>
				<article class="tap_area"><!-- tap_area start -->
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
						    <td id="changeBill_grpNo">
						    </td>
						    <th scope="row">Total Order In Group</th>
						    <td id="changeBill_ordGrp">
						    </td>
						</tr>
						<tr>
						    <th scope="row" rowspan="3">Current Bill Type</th>
						    <td colspan="3">
						    <label><input type="checkbox" id="changePop_post" name="changePop_post"/><span>Post</span></label>
						    </td>
						</tr>
						<tr>
						    <td colspan="3">
						    <label><input type="checkbox" id="changePop_sms" name="changePop_sms"/><span>SMS</span></label>
						    </td>
						</tr>
						<tr>
						    <td colspan="3">
						    <label><input type="checkbox" disabled="disabled"  id="changePop_estm" name="changePop_estm"/><span>E-Statement </span></label>
						    <input type="text" title="" placeholder="" class="readonly" id="changePop_estmVal" name="changePop_estmVal"/><p class="btn_sky"><a href="javascript:fn_reqNewMail();">Request New Email</a></p>
						    </td>
						</tr>
						<tr>
						    <th scope="row">Reason Update</th>
						    <td colspan="3">
						    <textarea cols="20" rows="5" placeholder="" id="changePop_Reason"></textarea>
						    </td>
						</tr>
						</tbody>
					</table><!-- table end -->
					<ul class="center_btns">
					    <li><p class="btn_blue2 big"><a href="javascript:fn_changeBillSave();">SAVE</a></p></li>
					</ul>
				</article><!-- tap_area end -->
				<article class="tap_area"><!-- tap_area start -->
					<article id="estmHisPopGrid" class="grid_wrap" style="width: 100%"><!-- grid_wrap start -->
					</article><!-- grid_wrap end -->
				</article><!-- tap_area end -->
			</section><!-- tap_wrap end -->
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<div id="chgMailAddrPop" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
			<h1>Billing Group Maintenance - Mailing Address</h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a href="#" onclick="fn_chgMailClose();">CLOSE</a></p></li>
			</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<ul class="right_btns">
			    <li><p class="btn_blue2"><a href="javascript:fn_addNewAddr();">Add New Address</a></p></li>
			    <li><p class="btn_blue2"><a href="javascript:fn_selectMailAddr();">Select Mailing Address</a></p></li>
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
			    <li><p class="btn_blue2 big"><a href="javascript:fn_newAddrSave();">SAVE</a></p></li>
			</ul>
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<div id="chgContPerPop" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
		<h1>Billing Group Maintenance - Contact Person</h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a href="#" onclick="fn_chgContPerPopClose();">CLOSE</a></p></li>
			</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<ul class="right_btns">
			    <li><p class="btn_blue2"><a href="javascript:fn_addNewConPerson();">Add New Contact</a></p></li>
			    <li><p class="btn_blue2"><a href="javascript:fn_selectContPerson();">Select Contact Person</a></p></li>
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
			    <li><p class="btn_blue2 big"><a href="javascript:fn_newContPersonSave();">SAVE</a></p></li>
			</ul>
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<div id="detailhistoryViewPop" class="popup_wrap size_mid" style="display: none"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
			<h1>Billing Group - History Details</h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
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
			    <li><p class="btn_blue2"><a href="#" onclick="fn_custAddrClose();">CLOSE</a></p></li>
			</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<ul class="right_btns">
			    <li><p class="btn_blue"><a href="javascript:fn_selectMailAddr();"><span class="search"></span>Search</a></p></li>
			    <li><p class="btn_blue"><a href="javascript:fn_keywordClear();"><span class="clear"></span>Clear</a></p></li>
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
			    <li><p class="btn_blue2"><a href="#" onclick="fn_contPerPopClose();">CLOSE</a></p></li>
			</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<ul class="right_btns">
			    <li><p class="btn_blue"><a href="javascript:fn_selectContPerson();"><span class="search"></span>Search</a></p></li>
			    <li><p class="btn_blue"><a href="javascript:fn_keywordClear2();"><span class="clear"></span>Clear</a></p></li>
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
	<div id="estmNewReqPop" class="popup_wrap size_small" style="display: none"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
			<h1>E-Statement - New Request</h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a href="#" onclick="fn_estmReqPopClose();">CLOSE</a></p></li>
			</ul>
		</header><!-- pop_header end -->
		<section class="pop_body"><!-- pop_body start -->
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:130px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Email</th>
					    <td>
					    <input type="text" id="newReqEmail" name="newReqEmail" title="" placeholder="" class="w100p" />
					    </td>
					</tr>
					<tr>
					    <th scope="row">Reason Update</th>
					    <td>
					    <textarea cols="20" rows="5" placeholder="" id="newReqReason"></textarea>
					    </td>
					</tr>
				</tbody>
			</table><!-- table end -->
			<ul class="center_btns">
			    <li><p class="btn_blue2 big"><a href="javascript:fn_newReqSave();">SAVE</a></p></li>
			</ul>
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<div id="contPersonAddPop" class="popup_wrap" style="display: none"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
		<h1>Billing Group Maintenance - Contact Person</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
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
			    <li><p class="btn_blue2"><a href="" onclick="fn_apprRequestClose();">CLOSE</a></p></li>
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
			    <li><p class="btn_blue2 big"><a href="javascript:fn_approveRequest('A');" id="btnApprReq">Approve Request</a></p></li>
			    <li><p class="btn_blue2 big"><a href="javascript:fn_approveRequest('C');" id="btnCancelReq">Cancel Request</a></p></li>
			</ul>
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<div id="removeOrderPop" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
			<h1>Billing Group Maintenance - Remove Order From Group</h1>
			<ul class="right_opt">
			    <li><p class="btn_blue2"><a href="#" onclick="fn_removeClose();">CLOSE</a></p></li>
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
			    <li><p class="btn_blue2 big"><a href="javascript:fn_removeOrdGrp();" id="btnSave">Save</a></p></li>
			</ul>
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
	<div id="addOrderPop" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
		<header class="pop_header"><!-- pop_header start -->
		<h1>Billing Group Maintenance - Add Order Into Group</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="" onclick="fn_addOrdPopClose();">CLOSE</a></p></li>
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
			    <li><p class="btn_blue2 big"><a href="javascript:fn_addOrdSave();">SAVE</a></p></li>
			</ul>
		</section><!-- pop_body end -->
	</div><!-- popup_wrap end -->
</body>