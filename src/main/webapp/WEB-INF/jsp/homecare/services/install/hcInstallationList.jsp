<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
    var myGridID;

    $(document).ready(function() {
	    //doGetCombo('/services/getProductList.do', '', '', 'product', 'S', '');
	    doGetComboAndGroup2('/common/selectProductCodeList.do', {selProdGubun: 'HC'}, '', 'product', 'M', 'fn_setOptGrpClass');//product 생성 - Only Homecare
	    //doGetComboSepa('/homecare/selectHomecareAndDscBranchList.do',  '', ' - ', '${SESSION_INFO.userBranchId}',   'dscCode', 'M', 'fn_multiCombo'); //Branch Code
	    doGetComboSepa('/common/selectBranchCodeList.do',  '6672', ' - ', '${SESSION_INFO.userBranchId}',   'dscCode', 'M', 'fn_multiCombo'); //Branch Code
        // added for HA & HC branch code enhancement - Hui Ding, 11/3/2024
	    doGetComboSepa('/common/selectBranchCodeList.do',  '11', ' - ', '${SESSION_INFO.userBranchId}',   'dscCode2', 'M', 'fn_multiCombo'); //Branch Code

	    createInstallationListAUIGrid();

	    console.log('isAC' + '${SESSION_INFO.isAC} ');
	    console.log("${SESSION_INFO.memberLevel}: " + '${SESSION_INFO.memberLevel}');
	    if('${SESSION_INFO.isAC}' == 1){
            if("${SESSION_INFO.memberLevel}" =="1"){
                $("#orgCode").val('${SESSION_INFO.orgCode}');
            }else if("${SESSION_INFO.memberLevel}" =="2"){
                $("#orgCode").val('${SESSION_INFO.orgCode}');
                $("#grpCode").val('${SESSION_INFO.groupCode}');
            }else if("${SESSION_INFO.memberLevel}" =="3"){
                $("#orgCode").val('${SESSION_INFO.orgCode}');
                $("#grpCode").val('${SESSION_INFO.groupCode}');
                $("#deptCode").val('${SESSION_INFO.deptCode}');
            }else if("${SESSION_INFO.memberLevel}" =="4"){
                $("#orgCode").val('${SESSION_INFO.orgCode}');
                $("#grpCode").val('${SESSION_INFO.groupCode}');
                $("#deptCode").val('${SESSION_INFO.deptCode}');
                //$("#memCode").val("${memCode}");
            }
        }

        AUIGrid.bind(myGridID, "rowAllChkClick", function( event ) {
            if(event.checked) {
                var uniqueValues = AUIGrid.getColumnDistinctValues(event.pid, "appTypeId");
                if(uniqueValues.indexOf("5764") != -1){
                    uniqueValues.splice(uniqueValues.indexOf("5764"),1);
                }
                AUIGrid.setCheckedRowsByValue(event.pid, "appTypeId", uniqueValues);
            } else {
                AUIGrid.setCheckedRowsByValue(event.pid, "appTypeId", []);
            }
        });

	    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
	       var statusCode = AUIGrid.getCellValue(myGridID, event.rowIndex, "code1");
	       Common.popupDiv("/homecare/services/install/installationResultDetailPop.do?isPop=true&installEntryId="+ AUIGrid.getCellValue(myGridID, event.rowIndex, "installEntryId") + "&codeId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "codeid1")
	    		   + "&salesOrderId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId"));
	    });

	    AUIGrid.bind(myGridID, "cellClick", function(event) {
	    	if( event.dataField != "attchmentDownload" ){
		        installEntryId = AUIGrid.getCellValue(myGridID, event.rowIndex, "installEntryId");
		        codeid1 = AUIGrid.getCellValue(myGridID, event.rowIndex, "codeid1");
		        orderId = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
		        docId = AUIGrid.getCellValue(myGridID, event.rowIndex, "c1");
		        statusCode = AUIGrid.getCellValue(myGridID, event.rowIndex, "code1");
		        salesOrderId = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
	    	}
            else if( event.dataField == "attchmentDownload" ){
	            if( FormUtil.isEmpty(event.value) == false){
	            	   var rowVal = AUIGrid.getItemByRowIndex(myGridID, event.rowIndex);

	            	   console.log("helloooo");
		               console.log(rowVal);
		               if( FormUtil.isEmpty(rowVal.atchFileName) == false && FormUtil.isEmpty(rowVal.physiclFileName) == false){
		            	   window.open("/file/fileDownWeb.do?subPath=" + rowVal.fileSubPath + "&fileName=" + rowVal.physiclFileName + "&orignlFileNm=" + rowVal.atchFileName);
		               }
	            }
            }
	    });

    });

    function fn_setOptGrpClass() {
        $("optgroup").attr("class" , "optgroup_text");
		fn_multiCombo();
    }

    function fn_disableGroupOption(){
	    $('.optgroup').children('input').attr("disabled","disabled");
	}

    function fn_multiCombo() {
        $('#dscCode').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });

        $('#dscCode2').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });

        $('#product').change(function(event) { //Added by Frango
			event.preventDefault();
			fn_disableGroupOption();
			$('#product').next().find('.placeholder').text('');
			$('#product').next().find('.placeholder').text($("#product option:selected").text());
		}).multipleSelect({
			selectAll : true, // 전체선택
			width : '100%'
		});
    }

    function fn_installationListSearch() {
        Common.ajax("GET", "/homecare/services/install/hcInstallationListSearch.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }

    // Add Install
    function fn_addInstallation(codeid1) {
        var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
	    if (selectedItems.length <= 0) {
	        // NO DATA SELECTED.
            Common.alert("<spring:message code='service.msg.NoRcd'/> ");
            return;
	    }

	    if (selectedItems.length > 1) {
	        // ONLY SELECT ONE ROW PLEASE
            Common.alert("<b><spring:message code='service.msg.onlyPlz'/><b>");
            return;
	    }

        var installEntryId = selectedItems[0].item.installEntryId;
	    var codeid1 = selectedItems[0].item.codeid1;
	    var orderId = selectedItems[0].item.salesOrdId;
	    var docId = selectedItems[0].item.c1;
	    var statusCode = selectedItems[0].item.code1;
	    var salesOrderId = selectedItems[0].item.salesOrdId;
	    var salesOrdNo1 = selectedItems[0].item.salesOrdNo;
	    var rcdTms = selectedItems[0].item.rcdTms;

	    Common.ajax("POST", "/services/selRcdTms.do", {installEntryId : installEntryId, orderId : orderId, rcdTms : rcdTms}, function(result) {
	        if (result.code == "99") {
	            Common.alert(result.message);
	        } else {
	        	console.log("/homecare/services/install/hcAddInstallationPopup.do?isPop=true&installEntryId="+ installEntryId
                        + "&codeId=" + codeid1
                        + "&salesOrderId=" + salesOrderId
                        + "&salesOrderNO=" + salesOrdNo1, "", null,
                        "false", "addInstallationPopupId");
	            if (statusCode == "ACT") {
		            if (codeid1 == 257) { // INSTALLATION
		                Common.popupDiv("/homecare/services/install/hcAddInstallationPopup.do?isPop=true&installEntryId="+ installEntryId
                            + "&codeId=" + codeid1
		                    + "&salesOrderId=" + salesOrderId
		                    + "&salesOrderNO=" + salesOrdNo1, "", null,
		                    "false", "addInstallationPopupId");
		            } else { // PRODUCT RETURN
		                Common.popupDiv("/homecare/services/install/hcAddinstallationResultProductDetailPop.do?isPop=true&installEntryId="+ installEntryId
	                        + "&codeId=" + codeid1
		                    + "&orderId=" + orderId + "&docId=" + docId
		                    + "&salesOrderId=" + salesOrderId, "", null,
		                    "false", "addinstallationResultProductDetailPopId");
		            }
		        } else {
		            // INSTALLATION IS NO LONGER ACTIVE. ADD NEW INSTALLATION RESULT IS DISALLOWED.
	                Common.alert("<spring:message code='service.msg.InstallationAdd'/> ");
	            }
	        }
	    })
    }


    function createInstallationListAUIGrid() {
	    var columnLayout = [
	        {dataField : "code",             headerText : '<spring:message code="service.grid.Type" />',             editable : false,     width : 80},
	        {dataField : "preinsInd",   headerText : 'Pre-Installation Check',        editable : false,     width : 130},
	        {dataField : "installEntryNo",   headerText : '<spring:message code="service.grid.InstallNo" />',        editable : false,     width : 130},
	        {dataField : "salesOrdNo",       headerText : '<spring:message code="service.grid.OrderNo" />',        editable : false,     width : 110},
	        {dataField : "c3",               headerText : '<spring:message code="service.grid.AppDate" />',        editable : false,     width : 100},
	        {dataField : "delvryGr",headerText : 'Stock Out GR',width : 130},
            {dataField : "returnGr",headerText : 'Stock Return GR',width : 130},
	        {dataField : "stkDesc",          headerText : '<spring:message code="service.grid.Product" />',         editable : false,     style : "my-column aui-grid-user-custom-left",    width : 380},
	        {dataField : "custId",           headerText : '<spring:message code="service.grid.CustomerId" />',    editable : false,     width : 100},
	        {dataField : "custName",           headerText : '<spring:message code="service.title.CustomerName" />',    editable : false,     width : 100},
	        {dataField : "memCode",          headerText : '<spring:message code="home.lbl.dtCode" />',         editable : false,     width : 100},
	        {dataField : "dtPairCode",          headerText : 'DT Pair',         editable : false,     width : 100},
	        {dataField : "appType",          headerText : '<spring:message code="service.grid.AppType" />',       editable : false,     width : 80},
	        {dataField : "bndlNo",           headerText : 'Bundle No',                                                             editable : false,     width : 120},
	        {dataField : "brnchCode",        headerText : '<spring:message code="service.grid.BranchCode" />',   editable : false,     width : 100},
	        {dataField : "code1",            headerText : '<spring:message code="service.grid.Status" />',            width : 100},
	        {
                dataField : "attchmentDownload",
                width:100,
                headerText : "<spring:message code='pay.head.attachment'/>",
                renderer : { type : "ImageRenderer",
                             width : 20,
                             height : 20,
                             imgTableRef : {
                               "DOWN": "${pageContext.request.contextPath}/resources/AUIGrid/images/arrow-down-black-icon.png"
                             }
                }
            },
	        {dataField : "allowCommision",     headerText:'Allow Commission',width: 150}, //Added by Keyi
	        {dataField : "disposalCommission",     headerText:'Disposal Commission',width: 150},
	        {dataField : "serialRequireChkYn",headerText : 'Serial Require Check Y/N',width : 180}, //Added by Keyi
	        {dataField : "lstUpd",           headerText : '<spring:message code="service.grid.UpdateBy" />',       width : 130},
	        {dataField : "brnchId",          width : 0},
	        {dataField : "installEntryId",   width : 0},
	        {dataField : "codeid1",          width : 0},
	        {dataField : "c1",               width : 0},
	        {dataField : "salesOrdId",       width : 0},
	        {dataField : "rcdTms",           width : 0},
	        {dataField : "appTypeId",        width : 0, visible:false},
	        {dataField : "telM1",headerText : '<spring:message code="service.title.MobileNo" />',width : 130},
	        {dataField : "telO",headerText : '<spring:message code="service.title.ResidenceNo" />',width : 130},
	        {dataField : "telR",headerText : '<spring:message code="service.title.OfficeNo" />',width : 130},
	        {dataField : "areaId",headerText : 'Area ID',width : 130},
	        {dataField : "brnchCode2", headerText : '<spring:message code="service.title.DSCBranch" />'}, // added for HA & HC branch code enhancement - Hui Ding, 5/3/2024
	        {dataField : "brnchId" , width : 0, visible: false}, // added for HA & HC branch code enhancement - Hui Ding, 5/3/2024
	        {dataField : "lastUpdCallLogDt",headerText : 'Last Updated Call Log Date',width : 200},
	        {dataField : "hpName",headerText : '<spring:message code="sal.text.salPersonName" />',width : 150},
	        {dataField : "hpContact",headerText : '<spring:message code="sal.text.salPersonPhone" />',width : 150},
	        {dataField : "remark",headerText : '<spring:message code="service.title.Remark" />',width : 500},
	        {dataField : "addrDtl",headerText : '<spring:message code="sal.text.addressDetail" />',width : 200},
	        {dataField : "street",headerText : '<spring:message code="sal.text.street" />',width : 200},
	        {dataField : "area",headerText : '<spring:message code="sys.area" />',width : 200},
	        {dataField : "city",headerText : '<spring:message code="sys.city" />',width : 130},
	        {dataField : "postcode",headerText : '<spring:message code="sys.postcode" />',width : 130},
	        {dataField : "state",headerText : '<spring:message code="sys.state" />',width : 130}
	        ,{dataField : "ordStusCodeId",        width : 0, visible:false}
	    ];

	    var gridPros = {
	      usePaging : true,
	      pageRowCount : 20,
	      showRowCheckColumn : true,
	      independentAllCheckBox : true,
	      showRowAllCheckBox : true,
	      editable : false,
	      wordWrap: true,
	      rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
	          if(item.appTypeId == "5764" && !(item.ordStusCodeId == "25" && item.code == "EXC")) { // AUX가  아닌 경우 체크박스 disabeld 처리함
	              return false; // false 반환하면 disabled 처리됨
	          }
	          return true;
	      }
	    };

	    myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
	}

    function fn_excelDown() {
        // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
        GridCommon.exportTo("grid_wrap", "xlsx", "<spring:message code='service.title.InstallationResultLogSearch'/>");
    }

  function fn_assginCTTransfer() {

    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    if (selectedItems.length <= 0) {
      Common.alert("<b><spring:message code='service.msg.NoRcd'/></b>");
      return;
    }

    var brnchId = selectedItems[0].item.brnchId;
    var serialRequireChkYn = selectedItems[0].item.serialRequireChkYn;

    if (brnchId == "") {
      Common.alert("<b>[" + selectedItems[i].item.installEntryNo
          + "] do no has any result[brnch] yet. .</br> ");
      return;
    }

    for ( var i in selectedItems) {
      if ("ACT" != selectedItems[i].item.code1) {
        Common.alert("<b>["
                + selectedItems[i].item.installEntryNo
                + "] do no has any result yet. .</br> Result view is disallowed.");
        return;
      }

      if (brnchId != selectedItems[i].item.brnchId) {
        Common.alert("<b><spring:message code='service.msg.BranchCode'/></b>");
        return;
      }

      if (serialRequireChkYn != selectedItems[i].item.serialRequireChkYn) {
          Common.alert("<b>Only the same 'Serial Require Chk Y/N' can be selected.</b>");
          return;
      }
    }

    var installEntryId = selectedItems[0].item.installEntryId;
    var orderId = selectedItems[0].item.salesOrdId;
    var rcdTms = selectedItems[0].item.rcdTms;

    Common.ajax("POST", "/services/selRcdTms.do", {
        installEntryId : installEntryId,
        orderId : orderId,
        rcdTms : rcdTms
      }, function(result) {
        if (result.code == "99") {
          Common.alert(result.message);
        } else {
          Common.popupDiv("/homecare/services/install/hcAssignDTTransferPop.do", null, null, true, '_assginCTTransferDiv');
        }
      });
  }

  function fn_installationNote() {
    Common.popupDiv("/homecare/services/install/report/installationNotePop.do", null, null, true, '');
  }

  /* By KV - Install Mobile Failure Listing*/
  function fn_InstallMobileFailureListing() {
    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();

    if (date.getDate() < 10) {
      day = "0" + date.getDate();
    }

    $("#reportFormInstLst #reportFileName").val('/services/Installation_Mobile_Fail_excel.rpt');
    $("#reportFormInstLst #viewType").val("EXCEL");
    $("#reportFormInstLst #V_TEMP").val("");
    $("#reportFormInstLst #reportDownFileName").val(
        "InstallMobileFailureListing_" + day + month + date.getFullYear());

    var option = {
      isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
    };

    Common.report("reportFormInstLst", option);
  }

  function fn_doActiveList() {
    Common.popupDiv("/homecare/services/install/report/doActiveListPop.do", null, null, true, '');
  }

  function fn_installRawData() {
    Common.popupDiv("/homecare/services/install/report/installationRawDataPop.do", null, null, true, '');
  }

  function fn_installBookListing() {
    Common.popupDiv("/homecare/services/install/report/installationLogBookPop.do", null, null, true, '');
  }

  function fn_dailyDscReport() {        // TO-BE : Coming soon ?
    Common.popupDiv("/homecare/services/install/report/dailyDscReportPop.do", null, null, true, '');
  }

  function fn_installNoteListing() {
    Common.popupDiv("/homecare/services/install/report/installationNoteListingPop.do", null, null, true, '');
  }
  function fn_installFreeGiftList() {
    Common.popupDiv("/homecare/services/install/report/installationFreeGiftListPop.do", null, null, true, '');
  }
  function fn_DscReport() {             // TO-BE : Coming soon ?
    Common.popupDiv("/homecare/services/install/report/installationDscReportPop.do", null, null, true, '');
  }
  function fn_installAccRawData() {
	Common.popupDiv("/homecare/services/install/report/hcInstallationAccessoriesRawPop.do", null, null, true, '');
  }

  function fn_editInstallation() {

    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    if (selectedItems.length <= 0) {
      Common
          .alert("<spring:message code='service.msg.NoRcd'/>");
      return;
    }

    if (selectedItems.length > 1) {
      Common.alert("<b><spring:message code='service.msg.onlyPlz'/></b>");
      return;
    }

    var installEntryId = selectedItems[0].item.installEntryId;
    var codeid1 = selectedItems[0].item.codeid1;
    var orderId = selectedItems[0].item.salesOrdId;
    var docId = selectedItems[0].item.c1;
    var statusCode = selectedItems[0].item.code1;
    var salesOrderId = selectedItems[0].item.salesOrdId;
    var rcdTms = selectedItems[0].item.rcdTms;

    Common.ajax("POST", "/services/selRcdTms.do", {
        installEntryId : installEntryId,
        orderId : orderId,
        rcdTms : rcdTms
      }, function(result) {
        if (result.code == "99") {
          Common.alert(result.message);
        } else {
          if (statusCode == "COM") {
            Common.popupDiv("/homecare/services/install/hcEditInstallationResultPop.do?isPop=true&installEntryId=" + installEntryId + "&codeId=" + codeid1 + "&salesOrderId=" + orderId);
          } else {
            //Common.alert("<b>Only completed installation result is allowed to edit.</b>");
            Common.alert("<b><spring:message code='service.msg.Onlycompleted'/></b>");
          }
        }
      });
  }

  function f_multiCombo2() {
    $('#product').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '80%'
    });
  }

    function fn_clear() {
		$("#type").val("");
		$("#installNo").val("");
		$("#startDate").val("");
		$("#endDate").val("");
		$("#instalStrlDate").val("");
		$("#installEndDate").val("");
		$("#orderNo").val("");
		$("#orderRefNo").val("");
		$("#poNo").val("");
		$("#orderDate").val("");
		$("#appType").val("");
		$("#installStatus").val("");
		$("#ctCode").val("");
		$("#dscCode").val("");
		$("#dscCode2").val("");
		$("#customerId").val("");
		$("#customerName").val("");
		$("#customerIc").val("");
		$("#sirimNo").val("");
		$("#serialNo").val("");
		$("#product").val("");
    }


    function fn_failInstallation() {//active 일때만 열림

        var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

        if (selectedItems.length <= 0) {
          Common.alert("<spring:message code='service.msg.NoRcd'/>");
          return;
        }

        if (selectedItems.length > 1) {
          Common.alert("<b><spring:message code='service.msg.onlyPlz'/></b>");
          return;
        }

        var installEntryId = selectedItems[0].item.installEntryId;
        var codeid1 = selectedItems[0].item.codeid1;
        var orderId = selectedItems[0].item.salesOrdId;
        var docId = selectedItems[0].item.c1;
        var statusCode = selectedItems[0].item.code1;
        var salesOrderId = selectedItems[0].item.salesOrdId;
        var rcdTms = selectedItems[0].item.rcdTms;

        Common.ajax("POST", "/services/selRcdTms.do", {
            installEntryId : installEntryId,
            orderId : orderId,
            rcdTms : rcdTms
          }, function(result) {
            if (result.code == "99") {
              Common.alert(result.message);
            } else {
              if (statusCode == "FAL") {
                Common.popupDiv("/homecare/services/install/hcFailInstallationPopup.do?isPop=true&installEntryId=" + installEntryId + "&codeId=" + codeid1 + "&salesOrderId=" + orderId);

              } else {

                Common.alert("Only Fail installation result is allowed to edit.");
              }
            }
          });
      }

    function fn_pdfDown(){

    	 const reportFormInstLst = document.getElementById("reportFormInstLst");

         let checkDetails = AUIGrid.getCheckedRowItemsAll(myGridID), installList = "";

    	 if(AUIGrid.getGridData(myGridID).map(d => d.installEntryNo).length){

    	     document.querySelectorAll(".reportInput").forEach(e=>e.remove());

    	     document.querySelectorAll("#searchForm input.forPdf").forEach(e => {
                 reportFormInstLst.innerHTML += `<input class="reportInput" type="hidden" value="`+e.value+`" name="`+e.name+`"/>`;
             });

	         document.querySelectorAll("#searchForm select.forPdf").forEach(e=> {
	                 if(e.name == "type"){
	                     reportFormInstLst.innerHTML += `<input class="reportInput" type="hidden" value="` + ($("#"+e.id).val() ? $("#"+e.id).val() : '') + `" name="`+e.name+`2"/>`;
	                 }else{
	                     reportFormInstLst.innerHTML += `<input class="reportInput" type="hidden" value="` + ($("#"+e.id).val() ? $("#"+e.id).val() : '') + `" name="`+e.name+`"/>`;
	                 }
	         });

    		 if(checkDetails.length>0){
                 for(let i=0; i<checkDetails.length;i++){
                     installList += "'"+checkDetails[i].installEntryNo+"',"
                  }
                  installList +="''";
                  document.querySelectorAll(".reportInput").forEach(e=> {
	                	  if(e.name == "installNo"){
	                	      e.value = installList;
	                	  }else{
	                	      e.value="";
	                	  }
                   });
    		 }

	         $("#reportFormInstLst #reportFileName").val('/homecare/preInsQr.rpt');
	         $("#reportFormInstLst #viewType").val("PDF");
	         $("#reportFormInstLst #reportDownFileName").val("preInstallationQrListing_" + moment().format("YYYYMMDD"));

	         Common.report("reportFormInstLst", { isProcedure : true});
    	 }else{
    		 Common.alert("Not allow to generate report with empty listing.")
    	 }
    }

</script>
<section id="content">
 <!-- content start -->
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
   alt="Home" /></li>
  <li>Sales</li>
  <li>Order list</li>
 </ul>
 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#none" class="click_add_on">My menu</a>
  </p>
  <h2>
   <spring:message code='service.title.InstallationResultList' />
  </h2>
  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue">
      <a href="#none" onClick="javascript:fn_assginCTTransfer()"><spring:message code='home.btn.assginDTTransfer' /></a>
     </p></li>
   </c:if>
   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue">
      <a href="#none" onclick="javascript:fn_installationListSearch()"><span class="search"></span>
      <spring:message code='sys.btn.search' /></a>
     </p></li>
   </c:if>
   <li><p class="btn_blue">
     <a href="#none" onClick="javascript:fn_clear()"><span class="clear"></span>
     <spring:message code='sal.btn.clear' /></a>
    </p></li>
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
  <form id='reportFormInstLst' method="post" name='reportFormInstLst' action="#">
    <input type='hidden' id='reportFileName' name='reportFileName'/>
    <input type='hidden' id='viewType' name='viewType'/>
    <input type='hidden' id='reportDownFileName' name='reportDownFileName'/>
    <input type='hidden' id='V_TEMP' name='V_TEMP'/>
    <input type="hidden" id="preInsQrParams" name="preInsQrParams">
  </form>

  <form action="#" method="post" id="searchForm">
  <input type="hidden" class="forPdf" id="orgCode" name="orgCode" value="" />
  <input type="hidden" class="forPdf" id="grpCode" name="grpCode" value="" />
  <input type="hidden" class="forPdf" id="deptCode" name="deptCode" value="" />


   <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 170px" />
     <col style="width: *" />
     <col style="width: 150px" />
     <col style="width: *" />
     <col style="width: 230px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message code='service.title.Type' /></th>
      <td><select class="multy_select w100p forPdf" multiple="multiple"
       id="type" name="type">
       <c:forEach var="list" items="${instTypeList }" varStatus="status">
         <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
        <!-- <option value="257">New Installation Order</option>
        <option value="258">Product Exchange</option> -->
      </select></td>
      <th scope="row"><spring:message
        code='service.title.InstallNo' /></th>
      <td><input type="text" class="w100p forPdf" title="Install No." placeholder="Install No."
       id="installNo" name="installNo" /></td>
      <th scope="row"><spring:message
        code='service.title.AppointmentDate' /></th>
      <td>
       <div class="date_set w100p">
        <!-- date_set start -->
        <p>
         <input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" class="j_dateHc forPdf" id="startDate"
          name="startDate" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="Create end Date"
          placeholder="DD/MM/YYYY" class="j_dateHc forPdf" id="endDate"
          name="endDate" />
        </p>
       </div>
       <!-- date_set end -->
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message
        code='service.title.InstallDate' /></th>
      <td>
       <div class="date_set w100p">
        <!-- date_set start -->
        <p>
         <input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" class="j_dateHc forPdf" id="instalStrlDate"
          name="instalStrlDate" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="Create end Date"
          placeholder="DD/MM/YYYY" class="j_dateHc forPdf" id="installEndDate"
          name="installEndDate" />
        </p>
       </div>
       <!-- date_set end -->
      </td>
      <th scope="row"><spring:message code='service.title.OrderNo' /></th>
      <td><input type="text" class="w100p forPdf" title="Order No." placeholder="Order No."
       id="orderNo" name="orderNo" /></td>
      <th scope="row"><spring:message
        code='service.title.OrderRefNo' /></th>
      <td><input type="text" class="w100p forPdf" title="Order Ref. No." placeholder="Order Ref. No."
       id="orderRefNo" name="orderRefNo" /></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.title.PONo' /></th>
      <td><input type="text" class="w100p forPdf" title="PO No." placeholder="PO No."
       id="poNo" name="poNo" /></td>
      <th scope="row"><spring:message
        code='service.title.OrderDate' /></th>
      <td><input type="text" title="Create start Date"
       placeholder="DD/MM/YYYY" class="j_dateHc w100p forPdf" id="orderDate"
       name="orderDate" /></td>
      <th scope="row"><spring:message
        code='service.title.ApplicationType' /></th>
      <td><select class="multy_select w100p forPdf" multiple="multiple"
       id="appType" name="appType">
        <c:forEach var="list" items="${appTypeList }" varStatus="status">
         <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
      </select></td>
     </tr>
     <tr>
      <th scope="row"><spring:message
        code='service.title.InstallationStatus' /></th>
      <td><select class="multy_select w100p forPdf" multiple="multiple"
       id="installStatus" name="installStatus">
        <c:forEach var="list" items="${installStatus }"
         varStatus="status">
         <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
      </select></td>
      <th scope="row">DT Code</th>
      <td><input type="text" class="w100p forPdf" title="DT Code" placeholder="DT Code" id="ctCode" name="ctCode" /></td>
      <th scope="row">DT Branch</th>
      <td>
        <select class="multy_select w100p forPdf" multiple="multiple" id="dscCode" name="dscCode">
      </select>
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.title.CustomerID' /></th>
      <td><input type="text" class="w100p forPdf" title="Customer ID" placeholder="Customer ID" id="customerId" name="customerId" /></td>
      <th scope="row"><spring:message code='service.title.CustomerName' /></th>
      <td><input type="text" class="w100p forPdf" title="Customer Name" placeholder="Customer Name" id="customerName" name="customerName" /></td>
      <th scope="row">DSC Branch</th>
      <td>
        <select class="multy_select w100p forPdf" multiple="multiple" id="dscCode2" name="dscCode2">
      </select>
     </tr>
	<tr>
        <th scope="row"><spring:message code='service.title.SIRIMNo' /></th>
        <td><input type="text" class="w100p forPdf" title="SIRIM No." placeholder="SIRIM No." id="sirimNo" name="sirimNo" /></td>
	    <th scope="row"><spring:message code='service.title.SerialNo' /></th>
	    <td><input type="text" class="w100p forPdf" title="Serial No." placeholder="Serial No." id="serialNo" name="serialNo" /></td>
	    <th scope="row"><spring:message code='service.title.CustomerIC_CompanyNo' /></th>
	    <td><input type="text" class="w100p forPdf" title="NRIC/BRIC" placeholder="NRIC/BRIC" id="customerIc" name="customerIc" /></td>
	</tr>
     <tr>
      <th scope="row"><spring:message code='service.title.Product' /></th>
      <td ><select class="w100p forPdf" id="product" name="product"></select></td>
       <th scope="row">Stock Out GR</th>
     <td>
          <select id="listDelvryGr" name="delvryGr" class="multy_select w100p forPdf" multiple="multiple">
              <option value="Y">Yes</option>
              <option value="N">No</option>
              <option value="B">Blank</option>
          </select>
     </td>
     <th scope="row">Bundle No</th>
        <td><input type="text" class="w100p forPdf" title="Bundle No." placeholder="Bundle No." id="bndlNo" name="bndlNo" /></td>
     </tr>
     <tr>
           <th>Pre-Installation Check :</th>
           <td>
            <select id="preinsChk" name="preinsChk" class="multy_select w100p forPdf" multiple="multiple">
                    <option value="4">Pre-Com</option>
                    <option value="21">Pre-Fail</option>
                    <option value="0">Blank</option>
            </select>
           </td>
           <th scope="row">Stock Return GR</th>
		     <td>
		          <select id="listReturnGr" name="returnGr" class="multy_select w100p forPdf" multiple="multiple">
		              <option value="Y">Yes</option>
		              <option value="N">No</option>
		              <option value="B">Blank</option>
		          </select>
		     </td>
           <th></th>
           <td></td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
   <aside class="link_btns_wrap">
    <!-- link_btns_wrap start -->
    <p class="show_btn">
     <a href="#none"><img
      src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
      alt="link show" /></a>
    </p>
    <dl class="link_list">
     <dt>Link</dt>
     <dd>
      <ul class="btns">
       <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li><p class="link_btn">
          <a href="javascript:fn_addInstallation()" id="addInstallation"><spring:message
            code='service.btn.AddInstallationResult' /></a>
         </p></li>
       </c:if>
       <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
        <li><p class="link_btn">
          <a href="javascript:fn_editInstallation()"
           id="editInstallation"><spring:message code='service.btn.EditInstallationResult' /></a>
         </p></li>
       </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
        <li><p class="link_btn">
          <a href="javascript:fn_failInstallation()" id="failInstallation">
          <spring:message code='service.btn.FailInstallationResult' /></a>
         </p></li>
       </c:if>
      </ul>
      <ul class="btns">
       <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
        <li><p class="link_btn type2">
          <a href="#none" onclick="javascript:fn_doActiveList()"><spring:message
            code='service.btn.DOActiveList' /></a>
         </p></li>
         <li><p class="link_btn type2">
          <a href="#none" onclick="javascript:fn_installNoteListing()"><spring:message
            code='service.btn.InstallationNoteListing' /></a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="#none" onclick="javascript:fn_installationNote()"><spring:message
            code='service.btn.InstallationNote' /></a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="#none" onclick="javascript:fn_installBookListing()"><spring:message
            code='service.btn.InstallationLogBookListing' /></a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="#none" onclick="javascript:fn_installRawData()"><spring:message
            code='service.btn.InstallationRawData' /></a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="#none" onclick="javascript:fn_installFreeGiftList()"><spring:message
            code='service.btn.InstallationFreeGiftList' /></a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="#none" onclick="javascript:fn_dailyDscReport()"><spring:message
            code='service.btn.DailyDSCReport' /></a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="#none" onclick="javascript:fn_DscReport()"><spring:message
            code='service.btn.DSCReport' /></a>
         </p></li>
         <li><p class="link_btn type2">
          <a href="#" onclick="javascript:fn_installAccRawData()"><spring:message
            code='service.btn.InstallationAccRawData' /></a>
         </p></li>
       </c:if>
      </ul>
       <ul class="btns">
         <!-- By KV - Install Mobile Failure Listing -->
             <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
         <li><p class="link_btn type2">
               <a href="#none" onclick="javascript:fn_InstallMobileFailureListing()"><spring:message
                   code='service.btn.MobileFailListInst' /></a>
              </p></li>
          </c:if>
       </ul>
      <p class="hide_btn">
       <a href="#none"><img
        src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
        alt="hide" /></a>
      </p>
     </dd>
    </dl>
   </aside>
   <!-- link_btns_wrap end -->
   <br/>
   <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
	     <li>
	            <p class="btn_grid">
	                <a href="#none" onClick="fn_pdfDown()">Pre-Installation QR Code</a>
	            </p>
	     </li>
	     <li><p class="btn_grid">
	                <a href="#none" onClick="fn_excelDown()"><spring:message code='service.btn.Generate' /></a>
	           </p>
	     </li>
    </c:if>
   </ul>
   <article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrap"
     style="width: 100%; height: 500px; margin: 0 auto;"></div>
   </article>
   <!-- grid_wrap end -->
  </form>
 </section>
 <!-- search_table end -->
</section>
<!-- content end -->
