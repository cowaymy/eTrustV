<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<style type="text/css">
   /* 커스텀 칼럼 스타일 정의 */
   .my-column {
	    text-align: center;
	    margin-top: -20px;
	}
   /* .my-row-style { background:#FF5733; font-weight:bold; color:#22741C; } */

   .my-row-style {
    background:#FF5733;
    font-weight:bold;
    color:#22741C;
    text-decoration:underline;
    cursor: pointer;
    text-align: right;
}
</style>

<script type="text/javaScript">
	var popupObj;
	var listPopGridID;
	var gipDate = '${gipDate}';

	var scanInfoLayout = [
          {dataField:"delvryNo", visible:false}
        , {dataField:"delvryNoItm", visible:false}
        , {dataField:"delGiCmplt", visible:false}
        , {dataField:"itmCode", headerText:"Item Code", width:120}
        , {dataField:"itmName", headerText:"Item Description", width:280, style:"aui-grid-user-custom-left"}
        , {dataField:"serialChk", headerText:"Serial Chk", width:100}
        , {dataField:"delvryQty", headerText:"DELVRY QTY", width:100
            , style:"aui-grid-user-custom-right"
            , dataType:"numeric"
            , formatString:"#,##0"
        }
        , {dataField:"scanQty", headerText:"Scaned QTY", width:110
            , style:"aui-grid-user-custom-right aui-grid-link-renderer"
            , dataType:"numeric"
            , formatString:"#,##0"
            , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField){
                if(item.delvryQty != value && item.serialChk != "N"){
                    return "my-row-style";
                }else if(item.serialChk != "N"){
                    return "aui-grid-link-renderer1";
                }

                return "aui-grid-column-right";
            }
        }
        , {dataField:"serialRequireChkYn", visible:false}
    ];

    var scanInfoPros = {
		usePaging : false,
        editable : false,
        selectionMode : "singleCell",
        showRowNumColumn : true,
        enableFilter : true,
        showRowCheckColumn : false,
        showRowAllCheckBox : false,
        showStateColumn : false,
        showBranchOnGrouping : false,
        enableRestore: true,
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
    };

    $(document).ready(function(){
	    // Moblie Popup Setting
	    Common.setMobilePopup(true, false,'listPopGrid');
	    listPopGridID = GridCommon.createAUIGrid("listPopGrid", scanInfoLayout, null, scanInfoPros);

	    AUIGrid.bind(listPopGridID, "cellClick", function( event ) {
	        if(event.dataField == "scanQty"){
	            var item = event.item;
	            if(item.serialChk == "Y"){
	                fn_scanSearchPop(item);
	            }
	        }
	    });

	    if(Common.checkPlatformType() == "mobile") {
	    	$("#zDelyNo").val("${param.zDelyno}");    // delivery No
	    	$("#zFromLoc").val("${param.zReqloc}");
	    	$("#zToLoc").val("${param.zRcvloc}");
	    	//$("#zIoType").val("O");

	    } else {
	    	$("#zDelyNo").val($("#zDelyno").val());
	        $("#zFromLoc").val($("#zReqloc").val());
	        $("#zToLoc").val($("#zRcvloc").val());
	        //$("#zIoType").val("O");
	    }
	    // 조회


	    $("#btnPopSearch").click(function(){
	    	/* console.log('zDelyNo' ||  $("#zDelyNo").val());
	        var url = "/logistics/stocktransfer/goodReceiptPopList.do";
	        var arrDelvryNo = ($("#zDelyNo").val()).split(',');

	        if(arrDelvryNo.length == 0){
	            Common.alert("Please, check the mandatory value.");
	            return false;
	        }

	        // 초기화
	        $("#btnPopSerial").parent().addClass("btn_disabled");
	        $("#btnAllDel").parent().addClass("btn_disabled");
	        AUIGrid.setGridData(listPopGridID, []);

	        Common.ajax("GET" , url , {"delyList":arrDelvryNo} , function(data){
	            if(data.total > 0){
	                if(data.dataList[0].serialRequireChkYn == "Y"){
	                    var isSerial = false;
	                    $.each(data.dataList, function(i, row){
	                        if(row.serialChk == "Y"){
	                            isSerial = true;
	                        }
	                    });
	                    if(isSerial){
	                        $("#btnPopSerial").parent().removeClass("btn_disabled");
	                        $("#btnAllDel").parent().removeClass("btn_disabled");
	                    }
	                }
	                AUIGrid.setGridData(listPopGridID, data.dataList);
	            }

	        }); */
	    	fn_search();

	    });

	    // Close 버튼 이벤트
	    $("#btnClose").click(function() {
	    	fn_ClosePop();
	    });
	    // Save 버튼 이벤트
	    $("#btnSave").click(function() {
	    	if(!fn_saveVaild()) return;
	    	// 저장
	    	fn_grFuncSerial();
	    });

	    $("#btnPopSerial").click(function(){
	        if($(this).parent().hasClass("btn_disabled") == true){
	            return false;
	        }

	        var delveryNo = $("#zDelyNo").val();
	        $("#zDelvryNo").val(delveryNo);
	        $("#zDelyNo").val(delveryNo);
	        if(Common.checkPlatformType() == "mobile") {
	            popupObj = Common.popupWin("stoIssueForm", "/logistics/serialMgmtNew/serialScanCommonPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
	        } else{
	            Common.popupDiv("/logistics/serialMgmtNew/serialScanCommonPop.do", null, null, true, '_serialScanPop');
	        }
	    });



	    $("#btnAllDel").click(function(){
	        if($(this).parent().hasClass("btn_disabled") == true){
	            return false;
	        }

	        var msg = "";
	        if($("#zTrnscType").val() == "UM"){
	            msg = "Do you want to All Delete Delivery No ["+$("#zRstNo").val()+"]?";
	        }else{
	            msg = "Do you want to All Delete Delivery No ["+$("#zDelyNo").val()+"]?";
	        }

	        Common
	            .confirm(msg,
	                function(){
	                    var itemDs = {"allYn":"Y"
	                            , "rstNo":$("#zRstNo").val()
	                            , "dryNo":$("#zDelyNo").val()
	                            , "fromLocCode":$("#zFromLoc").val()
	                            , "toLocCode":$("#zToLoc").val()
	                            , "ioType":$("#zIoType").val()
	                            , "transactionType":$("#zTrnscType").val()};


	                        Common.ajax("POST", "/logistics/serialMgmtNew/deleteSerial.do"
	                                , itemDs
	                                , function(result){
	                                    $("#btnPopSearch").click();
	                                }
	                                , function(jqXHR, textStatus, errorThrown){
	                                    try{
	                                        if (FormUtil.isNotEmpty(jqXHR.responseJSON)) {
	                                            console.log("code : "  + jqXHR.responseJSON.code);
	                                            Common.alert("Fail : " + jqXHR.responseJSON.message);
	                                        }else{
	                                            console.log("Fail Status : " + jqXHR.status);
	                                            console.log("code : "        + jqXHR.responseJSON.code);
	                                            console.log("message : "     + jqXHR.responseJSON.message);
	                                            console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
	                                        }
	                                    }catch (e){
	                                        console.log(e);
	                                    }
	                       });

	                }
	        );
	    });
	    //fn_search();
	    var ingGrNo = $("#zDelyNo").val();
        var ioType =  $("#zIoType").val();
	    Common.ajax("POST", "/logistics/stocktransfer/clearSerialNo.do"
                        , {"grNo": ingGrNo, "ioType" : ioType}
                        , function(result){

                                  }
                                 , function(jqXHR, textStatus, errorThrown){
                                     try{
                                         console.log("Fail Status : " + jqXHR.status);
                                         console.log("code : "        + jqXHR.responseJSON.code);
                                         console.log("message : "     + jqXHR.responseJSON.message);
                                         console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                                     }catch (e){
                                         console.log(e);
                                     }
                                     Common.alert("Fail : " + jqXHR.responseJSON.message);
                         });
	    $("#btnPopSearch").click();
	});



 // Serial Search Pop
    function fn_scanSearchPop(item){
	 console.log("item.delvryNo " || item.delvryNo);
	 console.log("item.delvryNoItm " || item.delvryNoItm);
        $("#frmSearchScan #pDeliveryNo").val(item.delvryNo);
        $("#frmSearchScan #pDeliveryItem").val(item.delvryNoItm);
        $("#frmSearchScan #pStatus").val("I");

        console.log("pDeliveryNo " || $("#pDeliveryNo").val());
        console.log("pDeliveryItemhhh " || $("#pDeliveryItem").val());
        if(Common.checkPlatformType() == "mobile") {
            popupObj = Common.popupWin("frmSearchScan", "/logistics/SerialMgmt/scanSearchPop.do", {width : "1000px", height : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        } else{
            Common.popupDiv("/logistics/SerialMgmt/scanSearchPop.do", $("#frmSearchScan").serializeObject(), null, true, '_scanSearchPop');
        }

    }
    // 유효성 체크
    function fn_saveVaild() {
        if ($("#sGiptdate").val() == "") {
            Common.alert("Please select the GI Posting Date.");
            return false;
        }
        if ($("#sGiptdate").val() < gipDate) {
            Common.alert("Cannot select back date.");
            return false;
        }
        if ($("#sGiptdate").val() > gipDate) {
            Common.alert("Cannot select future date.");
            return false;
        }

        if ($("#sGipfdate").val() == "") {
          Common.alert("Please select the GI Doc Date.");
          return false;
        }
        if ($("#sGipfdate").val() < gipDate) {
            Common.alert("Cannot select back date.");
            return false;
        }
        if ($("#sGipfdate").val() > gipDate) {
            Common.alert("Cannot select future date.");
            return false;
        }

        return true;
    }

    // 저장
    function fn_grFuncSerial() {
        Common.ajax("POST", "/logistics/stocktransfer/StockTransferDeliveryIssueSerial.do", $("#stoIssueForm").serializeJSON(), function(result) {
            var message =result.message;

            if("00" != result.code) { // 성공이 아닌경우.
                Common.alert(message);
            } else {  // SUCCESS
                Common.alert(message + "<br/>MDN NO : " + result.data);
                $("#ingGrNo").val('');
                fn_ClosePop();
                // 재조회 한다.
                if($('#searchId') != null) $('#'+$('#searchId').val()).click();
            }

        }, function(jqXHR, textStatus, errorThrown) {
            Common.alert("Fail : " + jqXHR.responseJSON.message);
        });
    }

    // 조회
    function fn_search() {
        var arrDelvryNo = ($("#zDelyNo").val()).split(',');

        if(arrDelvryNo.length == 0){
            Common.alert("Please, check the mandatory value.");
            return false;
        }
        // 초기화
        AUIGrid.setGridData(listPopGridID, []);
        $("#delyno").val(arrDelvryNo);
        $("#sGiptdate").val(gipDate);
        $("#sGipfdate").val(gipDate);

        Common.ajax("GET", "/logistics/stocktransfer/goodReceiptPopList.do", $("#stoIssueForm").serialize(), function(data){
            AUIGrid.setGridData(listPopGridID, data);
            if(data.size > 0){
            	console.log('data more than 0' );
            }

        });

        console.log('zDelyNo2 ' ||  $("#zDelyNo").val());
        console.log('ingGrNo2 ' ||  $("#ingGrNo").val());
        $("#ingGrNo").val($("#zDelyNo").val());
    }

	function fn_ClosePop() {
		var ingGrNo = $("#ingGrNo").val();
		var ioType =  $("#zIoType").val();

	    console.log('ingGrNo close ' + $("#ingGrNo").val());
	    if(js.String.isEmpty($("#zDelyNo").val())){
			// Moblie Popup Setting
		    if(Common.checkPlatformType() == "mobile") {
		    	opener.fn_PopClose();
		    } else {
		    	if($('#_divStoIssuePop') != null) $('#_divStoIssuePop').remove();
		    	$("#search").click();
		    }
	    }else{
	        if(ingGrNo == ""){
	            $('#_divStoIssuePop').remove();
	            $("#search").click();
	        }else{
	            Common.alert("Upon closing, all temporary scanned serial no. will be removed (If Any).");

	            Common.ajax("POST", "/logistics/stocktransfer/clearSerialNo.do"
	                    , {"grNo": ingGrNo, "ioType" : ioType}
	                    , function(result){
	                     //Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
	                     // Moblie Popup Setting
	                     if(Common.checkPlatformType() == "mobile") {
	                         if( typeof(opener.fn_PopClose) != "undefined" ){
	                             opener.fn_PopClose();
	                         }else{
	                             window.close();
	                         }
	                     } else {
	                         //$("#btnSearch").click();
	                         $('#_divStoIssuePop').remove();
	                     }
	                              }
	                             , function(jqXHR, textStatus, errorThrown){
	                                 try{
	                                     console.log("Fail Status : " + jqXHR.status);
	                                     console.log("code : "        + jqXHR.responseJSON.code);
	                                     console.log("message : "     + jqXHR.responseJSON.message);
	                                     console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
	                                 }catch (e){
	                                     console.log(e);
	                                 }
	                                 Common.alert("Fail : " + jqXHR.responseJSON.message);
	                     });
	        }
	    }
	}



</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Good Receipt</h1>
<ul class="right_opt">
    <li><p class="btn_blue2 big"><a id="btnSave" >SAVE</a></p></li>
    <li><p class="btn_blue2"><a id="btnClose" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
    <form id="stoIssueForm" name="giForm" method="POST">
        <input type="hidden" name="zTrnscType" id="zTrnscType" value="US" />
        <input type="hidden" name="gtype" id="gtype" value="GR" />
        <input type="hidden" name="zIoType" id="zIoType" value="I" />
        <input type="hidden" name="delyno" id="delyno" />

        <input type="hidden" name="zDelvryNo" id="zDelvryNo" />
        <input type="hidden" name="zRstNo" id="zRstNo" />
        <input type="hidden" name="zFromLoc" id="zFromLoc" />
        <input type="hidden" name="zToLoc" id="zToLoc" />
        <input type="hidden" name="zGtype" id="zGtype" />
        <input type="hidden" name="zPrgName" id="zPrgName" />

        <input type="hidden" name="ingGrNo" id="ingGrNo" />

        <table class="type1">
	        <caption>search table</caption>
	        <colgroup>
	            <col style="width:150px" />
	            <col style="width:*" />
	        </colgroup>
	        <tbody>
                <tr>
                   <th scope="row">Delivery No</th>
                   <td ><input id="zDelyNo" name="zDelyNo" type="text" placeholder="" class="w100p readonly" readonly /></td>
                   </tr>
                <tr>
                    <th scope="row"><span class="must">*</span>GR Posting Date</th>
                    <td ><input id="sGiptdate" name="giptdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
                </tr>
                <tr>
                    <th scope="row"><span class="must">*</span>GR Doc Date</th>
                    <td ><input id="sGipfdate" name="gipfdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
                </tr>
                <tr>
                    <th scope="row">Header Text</th>
                    <td><input type="text" name="doctext" id="doctext" maxlength="50" class="w100p"/></td>
                </tr>
	        </tbody>
        </table>
    </form>

    <form id="frmSearchScan" name="frmSearchScan" method="POST">
        <input id="pDeliveryNo" name="pDeliveryNo" type="hidden" value="" />
        <input id="pDeliveryItem" name="pDeliveryItem" type="hidden" value="" />
        <input id="pRequestNo" name="pRequestNo" type="hidden" value="" />
        <input id="pRequestItem" name="pRequestItem" type="hidden" value="" />
        <input id="pStatus" name="pStatus" type="hidden" value="" />
        <input id="pSerialNo" name="pSerialNo" type="hidden" value="" />
    </form>

    <aside class="title_line">
       <h3>Serial Scan</h3>
       <ul class="right_btns">
            <li style="display:none;"><p class="btn_grid"><a id="btnPopSearch">Search</a></p></li>
            <li><p class="btn_grid"><a id="btnAllDel">Clear Serial</a></p></li>
            <li><p class="btn_grid"><a id="btnPopSerial">Serial Scan</a></p></li>
       </ul>
    </aside>
    <section class="search_result">
        <article class="grid_wrap">
            <div id="listPopGrid" class="autoGridHeight"></div>
        </article>
    </section>
    &nbsp;
    <ul class="center_btns autoFixArea">

    </ul>

</section>
</div>