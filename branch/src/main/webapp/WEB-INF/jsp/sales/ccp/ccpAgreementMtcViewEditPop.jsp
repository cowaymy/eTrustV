<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">

/* gride 동적 버튼 */
.edit-column {
    visibility:hidden;
}
</style>
<script type="text/javascript">

    //AUIGrid 생성 후 반환 ID
    var consignGridID;
    var msgGridID;
    var orderGridID;

    //isFile
    var fileResult;

    $(document).ready(function() {

        //createConsignGrid();
        createMsgGrid();
        createOrderGrid();


        //Call Ajax
        fn_getConsignmentAjax();
        fn_getMsgLogAjax();
        fn_getOrderAjax();


        doGetCombo("/sales/ccp/getMessageStatusCode.do", $("#_prgId").val() , '', '_msgStatus', 'S', '' );

        console.log("_prgId : " + $("#_prgId").val());
        console.log("_UpdPrgId : " + $("#_updPrgId").val());


        //Agreement Result Display
        fn_hideAgrResult();

        $("#_btnSave").click(function() {

            var isResult = false;

            isResult = fn_validation();

            if(isResult == false){
                return;
            }

            //Validation Success ()
            $("#_hiddenUpdMsgStatus").val($("#_msgStatus").val());

            Common.ajax("GET", "/sales/ccp/updateAgreementMtcEdit.do", $("#_saveForm").serialize() , function(result){
                //msg
                //result.msgLogSeq
            	$("#_upMsgId").val(result.msgLogSeq);
            	//Save Btn Disable
                $("#_btnSave").css("display" , "none");
                //List Reload
                fn_selectCcpAgreementListAjax();
                Common.confirm('<spring:message code="sal.confirm.msg.wantToUpload" />' , fn_fileUpload , "");

                //Send E-Mail
                if( ("7" == $("#_updPrgId").val() && "5" == $("#_msgStatus").val()) || "8" == $("#_updPrgId").val()){

                    Common.ajax("GET", "/sales/ccp/sendUpdateEmail.do", result, function(result){
                        console.log(result.message);

                   });
                }
            });
        });//btn Save End

        $("#_addNewConsign").click(function() {

            Common.popupDiv("/sales/ccp/addNewConsign.do", $("#_saveForm").serializeJSON(), null , true , '_consignDiv');

        });

        //preset Notification Period by Hui Ding, 2020-09-18
        var min = 0;
        var max = 6;
        var optionName = " Months";
        var select = document.getElementById('_notificationMonth');

	    for (var i = min; i<=max; i++){
	        var opt = document.createElement('option');
	        opt.value = i;
	        opt.innerHTML = i + optionName;
	        select.appendChild(opt);
	    }

	    document.getElementById('_notificationMonth').value = select;

	    // add early termination non crisis flag - only available at Agreement Verifying stage by Hui Ding, 2020-09-21
	    if ($("#_updErlTerNonCrisisChk").val() == '1'){
            $("#_erlTerNonCrisisChk").prop("checked" , true);
        } else{
            $("#_erlTerNonCrisisChk").prop("checked" , false);
        }

    }); // Document Ready End

    $(function(){
    	$("#_erlTerNonCrisisChk").change(function(){
    		var prevChk = $("#_updErlTerNonCrisisChk").val() == 1? true:  false;

            if ($("#_prgId").val() != '8'){
            	Common.alert("[Early Termination Non N/Crisis] flag only allow to be edited at [Agreement Verifying] stage.");
            	$("#_erlTerNonCrisisChk").prop("checked" , prevChk);
            }
        });
    });


    function fn_fileUpload(){

        var uploadParam = {msgId : $("#_upMsgId").val()};
        console.log("edit upload Params  : " + JSON.stringify(uploadParam));
        Common.popupDiv("/sales/ccp/openFileUploadPop.do", uploadParam , null , true , '_uploadDiv');

    }


//     function createConsignGrid(){

//         var consignColumnLayout = [

//                 {dataField : "userName" , headerText : '<spring:message code="sal.title.creator" />' , width : "10%"},
//                 {dataField : "agCnsgnRcivDt" , headerText : '<spring:message code="sal.title.text.recvDate" />' , width : "10%"},
//                 {dataField : "agCnsgnSendDt" , headerText : '<spring:message code="sal.title.text.sentDate" />' , width : "10%"},
//                 {
//                     dataField : "cnsgnUserIdHand",
//                     headerText : '<spring:message code="sal.combo.text.byHand" />',
//                     width:'10%',
//                     renderer : {
//                         type : "TemplateRenderer",
//                         editable : true // 체크박스 편집 활성화 여부(기본값 : false)
//                     },
//                     // dataField 로 정의된 필드 값이 HTML 이라면 labelFunction 으로 처리할 필요 없음.
//                     labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성
//                         var html = '';

//                         html += '<label><input type="checkbox"';

//                         if(item.cnsgnUserIdHand == 1){
//                             html+= ' checked = "checked"';
//                             html+= ' disabled = "disabled"';
//                         }else{
//                             html+= ' disabled = "disabled"';
//                         }

//                         html += '/></label>';

//                         return html;
//                     }

//                   },
//                 {dataField : "agCosignNo" , headerText : '<spring:message code="sal.title.text.consignNo" />' , width : "20%"},
//                 {dataField : "curierName" , headerText : '<spring:message code="sal.text.courier" />' , width : "30%"},
//                 {dataField : "codeName" , headerText : '<spring:message code="sal.title.text.agmReqstor" />' , width : "10%"}

//         ];

//          //그리드 속성 설정
//         var gridPros = {

//                 usePaging           : true,         //페이징 사용
//                 pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
//                 editable            : false,
//                 fixedColumnCount    : 1,
//                 showStateColumn     : false,
//                 displayTreeOpen     : false,
//    //             selectionMode       : "singleRow",  //"multipleCells",
//                 headerHeight        : 30,
//                 useGroupingPanel    : false,        //그룹핑 패널 사용
//                 skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
//                 wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
//                 showRowNumColumn    : true
//             };

//         consignGridID = GridCommon.createAUIGrid("consign_grid_wrap", consignColumnLayout,'', gridPros);
//     }

    function createMsgGrid(){
        //govAgMsgAttachFileName
        var msgColumnLayout = [

                                   {dataField : "userName" , headerText : '<spring:message code="sal.text.creator" />' , width : "10%"},
                                   {dataField : "govAgMsgCrtDt" , headerText : '<spring:message code="sal.text.created" />' , width : "10%"},
                                   {dataField : "name" , headerText : '<spring:message code="sal.title.status" />' , width : "10%"},
                                   {dataField : "govAgPrgrsName" , headerText : '<spring:message code="sal.title.text.prgss" />' , width : "10%"},
                                   {dataField : "govAgRoleDesc" , headerText : '<spring:message code="sal.text.dept" />' , width : "10%"},
                                   {dataField : "govAgMsg" , headerText : '<spring:message code="sal.title.text.msg" />' , width : "30%"},
                                   {dataField : "govAgMsgHasAttach" , headerText : '<spring:message code="sal.title.text.attatch" />' , width : "10%"},
                                   {dataField : "atchFileGrpId" , visible : false},
                                   {dataField : "atchFileId",  headerText : '<spring:message code="sal.title.text.download" />', width : '10%', styleFunction : cellStyleFunction,
                                         renderer : {
                                           type : "ButtonRenderer",
                                           labelText : "Download",
                                           onclick : function(rowIndex, columnIndex, value, item) {

                                        	   Common.showLoader();
                                                var fileId = value;
                                        	  $.fileDownload("${pageContext.request.contextPath}/file/fileDown.do", {
                                                   httpMethod: "POST",
                                                   contentType: "application/json;charset=UTF-8",
                                                   data: {
                                                       fileId: fileId
                                                   },
                                                   failCallback: function (responseHtml, url, error) {
                                                       Common.alert($(responseHtml).find("#errorMessage").text());
                                                   }
                                               }).done(function () {
                                                       Common.removeLoader();
                                                       console.log('File download a success!');
                                               }).fail(function () {
                                            	       Common.alert('<spring:message code="sal.alert.msg.fileMissing" />');
                                            	       Common.removeLoader();
                                               });



                                           }
                                         }
                                     }];

         //그리드 속성 설정
        var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : false,
                displayTreeOpen     : false,
       //         selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true
            };

        msgGridID = GridCommon.createAUIGrid("msgLog_grid_wrap", msgColumnLayout,'', gridPros);

    }

    function createOrderGrid(){

        var orderColumnLayout = [

                               {dataField : "salesOrdNo" , headerText : '<spring:message code="sal.text.ordNo" />' , width : "20%"},
                               {dataField : "name" , headerText : '<spring:message code="sal.title.text.customer" />' , width : "40%"},
                               {dataField : "govAgItmInstResult" , headerText : '<spring:message code="sal.title.text.installResult" />' , width : "20%"},
                               {dataField : "govAgItmRentResult" , headerText : '<spring:message code="sal.text.rentalStatus" />' , width : "20%"}

         ];

         //그리드 속성 설정
        var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : true,
                displayTreeOpen     : false,
    //            selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true
            };

        orderGridID = GridCommon.createAUIGrid("order_grid_wrap", orderColumnLayout,'', gridPros);
    }

    /* ### Call Ajax ### */
    function fn_getConsignmentAjax(){
         Common.ajax("GET", "/sales/ccp/selectConsignmentLogAjax",  $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(consignGridID, result);

         });
    }

    function fn_getMsgLogAjax(){
         Common.ajax("GET", "/sales/ccp/selectMessageLogAjax",  $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(msgGridID, result);

         });
    }

    function fn_getOrderAjax(){
         Common.ajax("GET", "/sales/ccp/selectContactOrdersAjax",  $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(orderGridID, result);

         });
    }

    function fn_resizeFun(value){

        if(value == 'agrInfo'){
             AUIGrid.resize(consignGridID, 940, 250);
             AUIGrid.resize(msgGridID, 940, 250);

        }

        if(value == 'order'){
            AUIGrid.resize(orderGridID, 940, 250);
        }
    }

    function fn_hideAgrResult(){

        //Agreement Type
        $("#_agrType").attr({"disabled" : "disabled" , "class" : "wp100 disabled"});

        //Agreement Period
        $("#_agrPeriodStart").attr("disabled" , "disabled");
        $("#_agrPeriodEnd").attr("disabled" , "disabled");

        //Agreement Result Remark
        $("#_resultRemark").attr("disabled" , "disabled");

        //Notification
        $("#_isNotification").attr({"disabled" : "disabled" , "class" : "wp100 disabled"});
        $("#_notificationMonth").attr({"disabled" : "disabled" , "class" : "wp100 disabled"});

        //Agreement Result (Div Tag)
        var stusId = $("#_govAgStusId").val();
        if(stusId == 4 || stusId == 10){
            $("#_agrResult").css("display" , "none");
        }else{
            $("#_agrResult").css("display" , "");
        }
    }

    function fn_statusChangeFunc(inputVal){

        //InitField
        fn_intiField();

        var tempVal = inputVal;

        if(tempVal == null || tempVal == ''){
            fn_hideAgrResult();
        }else{
            //Notification
            $("#_isNotification").attr({"disabled" : false , "class" : "wp100"});

            //Notification Month
            $("#_notificationMonth").attr({"disabled" : false , "class" : "wp100"});

            //Remark
            $("#_resultRemark").attr("disabled" , false);

            //Progress ID
            if($("#_prgId").val() == '10'){
                $("#_agrType").attr({"disabled" : false , "class" : "wp100"});
            }else{
                $("#_agrType").attr({"disabled" : "disabled" , "class" : "wp100 disabled"});
            }

            //inputValue Compare
            if(tempVal == '6' ||tempVal == '10'){

                $("#_agrType").attr({"disabled" : "disabled" , "class" : "wp100 disabled"});
                $("#_agrPeriodStart").attr("disabled" , "disabled");
                $("#_agrPeriodEnd").attr("disabled" , "disabled");

            }else{

                $("#_agrPeriodStart").attr("disabled" , false );
                $("#_agrPeriodEnd").attr("disabled" , false );
            }
        }
    }

    function fn_validation(){

        //msgStatus
        if(null == $("#_msgStatus").val() || '' == $("#_msgStatus").val() ){

            Common.alert('<spring:message code="sal.alert.msg.agrPrgsStusReq" />');
            return false;
        }

        //Start Date , End Date
        if($("#_msgStatus").val() == '5' || $("#_msgStatus").val() == '44'){

            if(null == $("#_agrPeriodStart").val() || '' == $("#_agrPeriodStart").val()){
                Common.alert('<spring:message code="sal.alert.msg.agrPeriodStDateReq" />');
                return false;
            }

            if(null == $("#_agrPeriodEnd").val() || '' == $("#_agrPeriodEnd").val()){
                Common.alert('<spring:message code="sal.alert.msg.agrPeriodEdDateReq" />');
                return false;
            }

            var startDateAr = $("#_agrPeriodStart").val().split('/');
            var endDateAr = $("#_agrPeriodEnd").val().split('/');
            var startChgStr = '';
            var endChgStr = '';
            startChgStr = startDateAr[2]+startDateAr[1]+startDateAr[0];
            endChgStr = endDateAr[2]+endDateAr[1]+endDateAr[0];

            if(startChgStr > endChgStr){

            	Common.alert('<spring:message code="sal.alert.msg.agrPeriodStDateCanNotBigEdDate" />');
                return false;
            }

        }

        if($("#_prgId").val() == '10'){

            if($("#_msgStatus").val() == '5' ){

                if(null == $("#_agrPeriodStart").val() || '' == $("#_agrPeriodStart").val() || null == $("#_agrPeriodEnd").val() || '' == $("#_agrPeriodEnd").val() ){
                    Common.alert('<spring:message code="sal.alert.msg.plzSelCntcPeriod" />');
                    return false;
                 }
            }

            if($("#_msgStatus").val() == '5' || $("#_msgStatus").val() == '44'){

                //_agrType
                if(null == $("#_agrType").val() || '' == $("#_agrType").val()){
                    Common.alert('<spring:message code="sal.alert.msg.agrTypeIsReq" />');
                    return false;
                }
            }
        }

        if($("#_prgId").val() == '7'){

            if($("#_msgStatus").val() == '6' ){

                if(null == $("#_agrPeriodStart").val() || '' == $("#_agrPeriodStart").val() || null == $("#_agrPeriodEnd").val() || '' == $("#_agrPeriodEnd").val() ){
                    Common.alert('<spring:message code="sal.alert.msg.agrSubmStgNotAllowRej" />');
                    return false;
                }
            }
        }

        // Added for EAR termination non national crisis, by Hui Ding 2020-10-20
        if($("#_prgId").val() == '8'){ // at verifying stage
        	 if($("#_msgStatus").val() == '6' ){ // if "reject"
        		 $("#_erlTerNonCrisisChk").prop("checked" , false); // reset Ear termination non national crisis flag to 0
        	 }
        }


        //Remark
        if(null == $("#_resultRemark").val() || '' == $("#_resultRemark").val()){
            Common.alert('<spring:message code="sal.alert.msg.resultRemIsReq" />');
            return false;
        }


        return true;
    }//Validation End

    function fn_intiField(){

        //Agr Type
        $("#_agrType").val('949');
        $("#_isNotification").val('false');
        $("#_notificationMonth").val('0');
        $("#_agrPeriodStart").val('');
        $("#_agrPeriodEnd").val('');
        $("#_resultRemark").val('');

    }

  //addcolum button hidden
    function cellStyleFunction(rowIndex, columnIndex, value, headerText, item, dataField){

        if(item.govAgMsgHasAttach == 'Yes'){
            return '';
        }else{
            return "edit-column";
        }
    }

</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<input type="hidden" id="_prgId" value="${infoMap.govAgPrgrsId}">
<input type="hidden" id="_govAgStusId" value="${infoMap.govAgStusId}">
<input type="hidden" id="_editDocNo" value="${infoMap.govAgBatchNo}">
<input type="hidden" id = "_updErlTerNonCrisisChk" value="${infoMap.erlTerNonCrisisChk}">
 <form  id="_searchForm">
    <input type="hidden" name="govAgId" value="${infoMap.govAgId}" id="_secGovAgId">
</form>
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.cntcAgrMtcView" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close" ><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<!--msg Hidden  -->
<input type="hidden" id="_upMsgId"  >
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on" onclick="javascript: fn_resizeFun('agrInfo')"><spring:message code="sal.title.text.agrInfo" /></a></li>
    <li><a href="#" onclick="javascript: fn_resizeFun('order')"><spring:message code="sal.title.text.cntcOrds" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.agrInformation" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />

    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agrNo" /></th>
    <td><span>${infoMap.govAgBatchNo}</span></td>
    <th scope="row"><spring:message code="sal.text.memberCode" /></th>
    <td><span>${infoMap.memCode}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agreeType" /></th>
    <td><span>${infoMap.codeName}</span></td>
    <th scope="row"><spring:message code="sal.text.createDate" /></th>
    <td><span>${infoMap.govAgCrtDt}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.quantity" /></th>
    <td><span>${infoMap.govAgQty}</span></td>
    <th scope="row"><spring:message code="sal.title.text.agrStatus" /></th>
    <td><span>${infoMap.name1}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.prgss" /></th>
    <td><span>${infoMap.govAgPrgrsName}</span></td>
    <th scope="row"><spring:message code="sal.text.creator" /></th>
    <td><span>${infoMap.userName}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agrStart" /></th>
    <td><span>${infoMap.govAgStartDt}</span></td>
    <th scope="row"><spring:message code="sal.title.text.agrExpiry" /></th>
    <td><span>${infoMap.govAgEndDt}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.latestRecvDate" /></th>
    <td><span>${infoMap.govAgLastRcivDt}</span></td>
    <th scope="row"><spring:message code="sal.title.text.latestSendDate" /></th>
    <td><span>${infoMap.govAgLastSendDt}</span></td>
</tr>
<tr>
    <th scope="row">SST Type</th>
    <td><span>${infoMap.corpCustType}</span></td>
    <th scope="row">Agreement Type</th>
    <td><span>${infoMap.agreementType}</span></td>
</tr>

<!-- Added for 36M Commission Payout enhancement 2.0 by Hui Ding, 2020-10-19 -->
<tr>
    <th scope="row">Early TER Non N/Crisis</th>
    <td>
        <c:choose>
	        <c:when test="${infoMap.govAgPrgrsId <= 8 }">
	           <c:choose>
	               <c:when test="${infoMap.erlTerNonCrisisChk == 1}">
	                   <span>Yes</span>
	               </c:when>
	               <c:otherwise>
	                   <span>-</span>
	               </c:otherwise>
	           </c:choose>
	        </c:when>
	        <c:otherwise>
	           <c:if test="${infoMap.erlTerNonCrisisChk == 1}">
	               <span>Yes</span>
	           </c:if>
	           <c:if test="${infoMap.erlTerNonCrisisChk != 1}">
                   <span>No</span>
               </c:if>
	        </c:otherwise>
	    </c:choose>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->


<article class="grid_wrap"><!-- grid_wrap start -->
<div id="order_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<!--<aside class="title_line"><!-- title_line start -->
<!--<h2><spring:message code="sal.title.text.consignmentLog" /></h2>-->
<!--</aside><!-- title_line end -->

<!--<ul class="right_btns">-->
<!--    <li><p class="btn_grid"><a href="#" id="_addNewConsign"><spring:message code="sal.title.text.addNewConsignment" /></a></p></li>-->
<!--</ul>-->

<!--<article class="grid_wrap"><!-- grid_wrap start -->
<!--<div id="consign_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>-->
<!--</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.msgLog" /></h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="msgLog_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<div id="_agrResult">

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.cntcAgrResult" /></h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form  method="get" id="_saveForm">
<input type="hidden" name="updAgrId" id="_updAgrId" value="${infoMap.govAgId}">
<input type="hidden" name="updPrgId" id="_updPrgId" value="${infoMap.govAgPrgrsId}">
<input type="hidden" name="hiddenUpdMsgStatus" id="_hiddenUpdMsgStatus">
<input type="hidden" name="pudAgrNo" id="_pudAgrNo" value="${infoMap.govAgBatchNo}">
<%-- <input type="hidden" id = "_updErlTerNonCrisisChk" value="${infoMap.erlTerNonCrisisChk}"> --%>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.msgStatus" /></th>
    <td>
    <select class="w100p" id="_msgStatus" onchange="javascript : fn_statusChangeFunc(this.value)" name="updMsgStatus"></select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.agreeType" /></th>
    <td>
    <select class="w100p" id="_agrType"  name="updAgrType">
        <option value="949"><spring:message code="sal.title.text.new" /></option>
        <option value="950"><spring:message code="sal.title.text.reNew" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.notification" /></th>
    <td colspan="3">
    <div class="date_set"><!-- date_set start -->
    <p>
    <select class="w100p" id="_isNotification" name="updIsNotification">
        <option value="false" selected="selected"><spring:message code="sal.title.text.no" /></option>
        <option value="true"><spring:message code="sal.title.text.yes" /></option>
    </select>
    </p>
    <p>
    <select class="w100p" id="_notificationMonth" name="updNotificationMonth"></select>
    </p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agrPrd" /></th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  readonly="readonly" id="_agrPeriodStart" name="updPeriodStart"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" readonly="readonly" id="_agrPeriodEnd" name="updPeriodEnd"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Early TER Non N/Crisis</th>
    <td>
        <%-- <c:choose>
            <c:when test="${infoMap.govAgPrgrsId == 8 }">
                <input type="checkbox" id="_erlTerNonCrisisChk" name="erlTerNonCrisisChk"/>
            </c:when>
            <c:otherwise> --%>
                <input type="checkbox" id="_erlTerNonCrisisChk" name="erlTerNonCrisisChk"/>
            <%-- </c:otherwise>
        </c:choose> --%>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.resultRem" /></th>
    <td colspan="3"><textarea cols="20" rows="5" id="_resultRemark" name="updResultRemark"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" id="_btnSave"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</div>

</section><!-- popBody end  -->
</div>