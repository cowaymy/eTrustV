<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 01/04/2019  ONGHC  1.0.0          RE-STRUCTURE JSP
 18/06/2019  ONGHC  1.0.1          AMENMENT BASED ON USER REQUEST
 -->

<script type="text/javaScript" language="javascript">

var asHistoryGrid;
var bsHistoryGrid;
var asNo;
var asrNo;

  $(document).ready(
    function() {
      AUIGrid.resize(asHistoryGrid, 1000, 300);
      AUIGrid.resize(bsHistoryGrid, 1000, 300);

      createASHistoryGrid();
      createBSHistoryGrid();

      fn_getASHistoryInfo();
      fn_getBSHistoryInfo();

      AUIGrid.setSelectionMode(asHistoryGrid, "singleRow");
      AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
        Common.popupDiv("/services/compensation/compensationViewPop.do?cpsNo=" + cpsNo, null, null, true, '_compensationViewPop');
      });

      AUIGrid.bind(asHistoryGrid, "cellClick", function(event) {
        asNo = AUIGrid.getCellValue(asHistoryGrid, event.rowIndex, "asNo");
        asrNo = AUIGrid.getCellValue(asHistoryGrid, event.rowIndex, "c2");

        if (AUIGrid.getCellValue(asHistoryGrid, event.rowIndex, "code") != "COM") {
            Common.alert("<b>* Selected record must in COMPLETE status.</b>");
        } else {
          $("#asNo").val(asNo);
          $("#asrNo").val(asrNo);

          $("#asNoHid").val(asNo);
          $("#asrNoHid").val(asrNo);
        }
      });

      setInputFile2();

      $("#m2").hide();
      $("#m4").hide();
      $("#m5").hide();
      $("#m6").hide();
      $("#m7").hide();
      $("#m8").hide();
      $("#m9").hide();
      $("#m10").hide();
      $("#m11").hide();
      $("#m12").hide();
      $("#m13").hide();
      $("#m14").hide();
      $("#m15").hide();

      $("#stusCodeId").change(
        function() {
          if ($("#stusCodeId").val() == "34" || $("#stusCodeId").val() == "35") {
            $("#m2").show();
            $("#m4").show();
            $("#m5").show();
            $("#m6").show();
            $("#m7").show();
            $("#m8").show();
            $("#m9").show();
            $("#m10").show();
            $("#m11").show();
            $("#m12").show();
            $("#m13").show();
            $("#m14").show();
            $("#m15").show();
          } else if ($("#stusCodeId").val() == "1" || $("#stusCodeId").val() == "44") {
            $("#m2").hide();
            $("#m4").hide();
            $("#m5").hide();
            $("#m6").hide();
            $("#m7").hide();
            $("#m8").hide();
            $("#m9").hide();
            $("#m10").hide();
            $("#m11").hide();
            $("#m12").hide();
            $("#m13").hide();
            $("#m14").hide();
            $("#m15").hide();
          } else if ($("#stusCodeId").val() == "10" || $("#stusCodeId").val() == "36") {
            $("#m2").show();
            $("#m4").hide();
            $("#m5").show();
            $("#m6").show();
            $("#m7").show();
            $("#m8").hide();
            $("#m9").hide();
            $("#m10").hide();
            $("#m11").hide();
            $("#m12").hide();
            $("#m13").hide();
            $("#m14").hide();
            $("#m15").hide();
          }
        });
    });

  function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'><spring:message code='commission.text.search.file' /></a></span></label><span class='label_text'><a href='#'><spring:message code='sys.btn.add' /></a></span><span class='label_text'><a href='#'><spring:message code='sys.btn.delete' /></a></span>");
  }

  function fn_gird_resize() {
    AUIGrid.resize(asHistoryGrid, 950, 300);
    AUIGrid.resize(bsHistoryGrid, 950, 300);
  }

  function createASHistoryGrid() {
    var cLayout = [ { dataField : "asNo",
                      headerText : '<spring:message code="service.grid.ASNo" />',
                      width : 100
                    }, {
                      dataField : "c2",
                      headerText : '<spring:message code="service.grid.ASRNo" />',
                      width : 100,
                      editable : false
                    }, {
                      dataField : "code",
                      headerText : '<spring:message code="service.grid.Status" />',
                      width : 80,
                      editable : false
                    }, {
                      dataField : "asReqstDt",
                      headerText : '<spring:message code="service.grid.ReqstDt" />',
                      width : 100,
                      editable : false,
                      dataType : '<spring:message code="service.grid.Date" />',
                      formatString : "dd-mm-yyyy"
                    }, {
                      dataField : "asSetlDt",
                      headerText : '<spring:message code="service.grid.SettleDate" />',
                      width : 100,
                      editable : false,
                      dataType : '<spring:message code="service.grid.Date" />',
                      formatString : "dd-mm-yyyy",
                      editable : false
                    }, {
                      dataField : "c3",
                      headerText : '<spring:message code="service.grid.ErrCde" />',
                      width : 100,
                      editable : false
                    }, {
                      dataField : "c4",
                      headerText : '<spring:message code="service.grid.ErrDesc" />',
                      width : 100,
                      editable : false
                    }, {
                      dataField : "c5",
                      headerText : '<spring:message code="service.grid.CTCode" />',
                      width : 100,
                      editable : false
                    }, {
                      dataField : "c6",
                      headerText : '<spring:message code="service.grid.Solution" />',
                      width : 100,
                      editable : false
                    }, {
                      dataField : "c7",
                      headerText : '<spring:message code="service.grid.Amt" />',
                      width : 80,
                      dataType : "number",
                      formatString : "#,000.00",
                      editable : false
                    }];

    var gridPros = { usePaging : true,
                     pageRowCount : 20,
                     editable : false,
                     fixedColumnCount : 1,
                     selectionMode : "singleRow",
                     showRowNumColumn : true
                   };

    asHistoryGrid = GridCommon.createAUIGrid("#ashistory_grid_wrap", cLayout, '', gridPros);
  }

  function createBSHistoryGrid() {
    var cLayout = [ { dataField : "eNo",
                      headerText : '<spring:message code="service.grid.HSNo" />',
                      width : 100
                    }, {
                      dataField : "edate",
                      headerText : '<spring:message code="service.grid.HSMth" />',
                      width : 100,
                      editable : false
                    }, {
                      dataField : "code",
                      headerText : '<spring:message code="service.grid.Type" />',
                      width : 80,
                      editable : false
                    }, {
                      dataField : "code1",
                      headerText : '<spring:message code="service.grid.Status" />',
                      width : 100,
                      editable : false
                    }, {
                      dataField : "no1",
                      headerText : '<spring:message code="service.grid.HSRNo" />',
                      width : 80,
                      editable : false
                    }, {
                      dataField : "c1",
                      headerText : '<spring:message code="service.grid.SettleDate" />',
                      width : 80,
                      dataType : "date",
                      formatString : "dd-mm-yyyy",
                      editable : false
                    }, {
                      dataField : "memCode",
                      headerText : '<spring:message code="service.grid.CodyCode" />',
                      width : 100
                    }, {
                      dataField : "code3",
                      headerText : '<spring:message code="service.grid.FailReason" />',
                      width : 100,
                      editable : false
                    }, {
                      dataField : "code2",
                      headerText : '<spring:message code="service.grid.CollectionReason" />',
                      width : 100,
                      editable : false
                    }];

    var gridPros = { usePaging : true,
                     pageRowCount : 20,
                     editable : false,
                     fixedColumnCount : 1,
                     selectionMode : "singleRow",
                     showRowNumColumn : true
                   };

    bsHistoryGrid = GridCommon.createAUIGrid("#bshistory_grid_wrap", cLayout, '', gridPros);
  }

  function fn_getASHistoryInfo() {
    Common.ajax("GET", "/services/as/getASHistoryList.do", {
      SALES_ORD_ID : '${orderDetail.basicInfo.ordId}',
      SALES_ORD_NO : '${orderDetail.basicInfo.ordNo}'
    }, function(result) {
      AUIGrid.setGridData(asHistoryGrid, result);
    });
  }

  function fn_getBSHistoryInfo() {
    Common.ajax("GET", "/services/as/getBSHistoryList.do", {
      SALES_ORD_NO : '${orderDetail.basicInfo.ordNo}',
      SALES_ORD_ID : '${orderDetail.basicInfo.ordId}'
    }, function(result) {
      AUIGrid.setGridData(bsHistoryGrid, result);
    });
  }

  function fn_close() {
    $("#_resultNewEntryPopDiv1").remove();
  }

  function fn_doSave() {
    if (!fn_cmpDt()) {
      return;
    }
    if (!fn_validate_field()) {
      return;
    }

    var formData = Common.getFormData("comPensationInfoForm");
    var obj = $("#comPensationInfoForm").serializeJSON();

    $.each(obj, function(key, value) {
      formData.append(key, value);
    });

    Common.ajaxFile("/services/compensation/insertCompensation.do", formData,
      function(result) {
        if (result.code == "00") {
          $("#_resultNewEntryPopDiv1").remove();
          fn_searchASManagement();
          Common.alert("<b>" + result.message + "</b>");
        } else {
          Common.alert("<b>" + result.message + "</b>");
        }
      });
  }

  function fn_validate_field() {
    var msg = "";
    var field = "";

    if ($("#stusCodeId").val() == "" || $("#stusCodeId").val() == null) {
      field = "<spring:message code='service.text.Status' />";
      msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
      field = "";
    }

    if ($("#stusCodeId").val() == "34" || $("#stusCodeId").val() == "35") { // SOLVED / UNSOLVED
      if ($("#asRqstDt").val() == "" || $("#asRqstDt").val() == null) {
        field = "<spring:message code='service.text.AsRqstDt' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#compDt").val() == "" || $("#compDt").val() == null) {
        field = "<spring:message code='service.grid.CompDt' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#comPensationInfoForm #asNoHid").val() == "" || $("#comPensationInfoForm #asNoHid").val() == null) {
        field = "<spring:message code='service.grid.ASNo' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#comPensationInfoForm #asrNoHid").val() == "" || $("#comPensationInfoForm #asrNoHid").val() == null) {
        field = "<spring:message code='service.grid.ASRs' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#stusCodeId").val() == "" || $("#stusCodeId").val() == null) {
        field = "<spring:message code='service.text.Status' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#compTotAmt").val() == "" || $("#compTotAmt").val() == null) {
        field = "<spring:message code='service.text.CpsAmt' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#searchdepartment").val() == "" || $("#searchdepartment").val() == null) {
        field = "<spring:message code='service.text.MngtDept' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#inChrDept").val() == "" || $("#inChrDept").val() == null) {
        field = "<spring:message code='service.text.InChrDept' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#branchCde").val() == "" || $("#branchCde").val() == null) {
        field = "<spring:message code='service.grid.Branch' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#issueDt").val() == "" || $("#issueDt").val() == null) {
        field = "<spring:message code='service.text.IssueDt' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#dfctPrt").val() == "" || $("#dfctPrt").val() == null) {
        field = "<spring:message code='service.text.DfctPrt' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#comPensationInfoForm #evtTyp").val() == "" || $("#comPensationInfoForm #evtTyp").val() == null) {
        field = "<spring:message code='service.grid.EvtTyp' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#solutionMtd").val() == "" || $("#solutionMtd").val() == null) {
        field = "<spring:message code='service.text.SolutionMtd' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#comPensationInfoForm #cause").val() == "" || $("#comPensationInfoForm #cause").val() == null) {
        field = "<spring:message code='service.grid.Cause' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#comPensationInfoForm #cpsTyp").val() == "" || $("#comPensationInfoForm #cpsTyp").val() == null) {
        field = "<spring:message code='service.grid.CpsTyp' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
    } else if ($("#stusCodeId").val() == "1" || $("#stusCodeId").val() == "44") {
      if ($("#asRqstDt").val() == "" || $("#asRqstDt").val() == null) {
        field = "<spring:message code='service.text.AsRqstDt' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#stusCodeId").val() == "" || $("#stusCodeId").val() == null) {
        field = "<spring:message code='service.text.Status' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
    } else if ($("#stusCodeId").val() == "10" || $("#stusCodeId").val() == "36") {
      if ($("#asRqstDt").val() == "" || $("#asRqstDt").val() == null) {
        field = "<spring:message code='service.text.AsRqstDt' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#compDt").val() == "" || $("#compDt").val() == null) {
        field = "<spring:message code='service.grid.CompDt' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#stusCodeId").val() == "" || $("#stusCodeId").val() == null) {
        field = "<sprng:message code='service.text.Status' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#searchdepartment").val() == "" || $("#searchdepartment").val() == null) {
        field = "<spring:message code='service.text.MngtDept' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#inChrDept").val() == "" || $("#inChrDept").val() == null) {
        field = "<spring:message code='service.text.InChrDept' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#branchCde").val() == "" || $("#branchCde").val() == null) {
        field = "<spring:message code='service.grid.Branch' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
    }

    if (msg != "") {
      Common.alert(msg);
      return false;
    } else {
      return true
    }
  }

  function fn_doClear() {
    $("#asNo").val("");
    $("#asrNo").val("");

    $("#asNoHid").val("");
    $("#asrNoHid").val("");
  }

  function isNumberKey(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57) && !(charCode == 46 || charCode == 8))
      return false;
    else {
      var len = $(element).val().length;
      var index = $(element).val().indexOf('.');
      if (index > 0 && charCode == 46) {
        return false;
      }
      if (index > 0) {
        var CharAfterdot = (len + 1) - index;
        if (CharAfterdot > 3) {
          return false;
        }
      }

    }
    return true;
  }

  function fn_getAsSumLst() {
    var ordNo = ${orderDetail.basicInfo.ordNo};
    var whereSql = "";

    if (ordNo == "" || ordNo == null) {
      var field = "<spring:message code='service.placeHolder.ordNo' />";
      var msg = "<b>* <spring:message code='sys.msg.invalid' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
      Common.alert(msg);
      return;
    }

    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();

    if (date.getDate() < 10) {
      day = "0" + date.getDate();
    }

    whereSql = "and (O.SALES_ORD_NO >= '" + ordNo + "' AND O.SALES_ORD_NO <= '" + ordNo + "') ";
    $("#comPensationInfoForm #reportFileName").val('/services/ASSummaryList.rpt');
    $("#comPensationInfoForm #reportDownFileName").val("ASSummaryList_" + day + month + date.getFullYear() + "_" + ordNo);
    $("#comPensationInfoForm #viewType").val("PDF");
    $("#comPensationInfoForm #V_SELECTSQL").val();
    $("#comPensationInfoForm #V_WHERESQL").val(whereSql);
    $("#comPensationInfoForm #V_GROUPBYSQL").val();
    $("#comPensationInfoForm #V_FULLSQL").val();
    $("#comPensationInfoForm #V_ASNOFORM").val();
    $("#comPensationInfoForm #V_ASNOTO").val();
    $("#comPensationInfoForm #V_ASRNOFROM").val();
    $("#comPensationInfoForm #V_ASRNOTO").val();
    $("#comPensationInfoForm #V_CTCODE").val();
    $("#comPensationInfoForm #V_DSCCODE").val();
    $("#comPensationInfoForm #V_REQUESTDATEFROM").val();
    $("#comPensationInfoForm #V_REQUESTDATETO").val();
    $("#comPensationInfoForm #V_APPOINDATEFROM").val();
    $("#comPensationInfoForm #V_APPOINDATETO").val();
    $("#comPensationInfoForm #V_ASTYPEID").val();
    $("#comPensationInfoForm #V_ASSTATUS").val();
    $("#comPensationInfoForm #V_ASGROUP").val();
    $("#comPensationInfoForm #V_ASTEMPSORT").val();
    $("#comPensationInfoForm #V_ORDNUMTO").val(ordNo);
    $("#comPensationInfoForm #V_ORDNUMFR").val(ordNo);

    var option = {
      isProcedure : true,
    };

    Common.report("comPensationInfoForm", option);
  }

  function fn_cmpDt() {
    if ($("#asRqstDt").val() != "" && $("#issueDt").val() != "") {
      var dt1 = getDateObj($("#asRqstDt").val());
      var dt2 = getDateObj($("#issueDt").val());

      if (dt1 < dt2) {
        var field1 = "<spring:message code='service.text.AsRqstDt' />";
        var field2 = "<spring:message code='service.grid.ReqstDt' />";

        Common.alert("<b>* <spring:message code='sys.msg.LessThnEql' arguments= '" + field2 + " ; " + field1 + "' htmlEscape='false' argumentSeparator=';'/></b><br/>");
        $("#issueDt").val("");
        return false;
      }
    }
    return true;
  }

  function getDateObj(dateString) {
    var parts = dateString.split('/');
    var month = parts[1];
    var date = parts[0];
    var year = parts[2];
    return new Date(year, month, date);
  }
</script>
<body>
 <div id="popup_wrap" class="popup_wrap">
  <!-- popup_wrap start -->
  <header class="pop_header">
   <!-- pop_header start -->
   <h1>Add Compensation Log Detail</h1>
   <ul class="right_opt">
    <li><p class="btn_blue2">
      <a href="#">CLOSE</a>
     </p></li>
   </ul>
  </header>
  <!-- pop_header end -->
  <section class="pop_body">
   <!-- pop_body start -->
   <section class="search_table">
    <!-- search_table start -->
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 100px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message
         code='service.placeHolder.ordNo' /></th>
       <td><input type="text" title="" id="entry_orderNo"
        name="entry_orderNo" value="${orderDetail.basicInfo.ordNo}"
        placeholder="<spring:message code='service.placeHolder.ordNo' />"
        class="readonly " readonly="readonly" />
        <p class="btn_sky" id="rbt">
          <a href="#" onclick="fn_getAsSumLst()"><spring:message code='service.btn.ASSumLst' /></a>
         </p></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </section>
   <!-- search_table end -->
   <div id='Panel_AS' style="display: inline">
    <section class="search_result">
     <!-- search_result start -->
     <section class="tap_wrap">
      <!-- tap_wrap start -->
      <ul class="tap_type1">
       <li><a href="#" class="on"><spring:message
          code='sal.tap.title.ordInfo' /></a></li>
       <li><a href="#" onclick="fn_gird_resize()"><spring:message
          code='sal.title.text.afterService' /></a></li>
       <li><a href="#" onclick="fn_gird_resize()"><spring:message
          code='sal.title.text.beforeService' /></a></li>
      </ul>
      <article class="tap_area">
       <!-- tap_area start -->
       <!------------------------------------------------------------------------------
          Order Detail Page Include START
          ------------------------------------------------------------------------------->
       <%@ include
        file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
       <!------------------------------------------------------------------------------
          Order Detail Page Include END
         ------------------------------------------------------------------------------->
      </article>
      <!-- tap_area end -->
      <article class="tap_area">
       <!-- tap_area start -->
       <article class="grid_wrap">
        <!-- grid_wrap start -->
        <div id="ashistory_grid_wrap"
         style="width: 100%; height: 300px; margin: 0 auto;"></div>
       </article>
       <!-- grid_wrap end -->
      </article>
      <!-- tap_area end -->
      <article class="tap_area">
       <!-- tap_area start -->
       <article class="grid_wrap">
        <!-- grid_wrap start -->
        <div id="bshistory_grid_wrap"
         style="width: 100%; height: 300px; margin: 0 auto;"></div>
       </article>
       <!-- grid_wrap end -->
      </article>
      <!-- tap_area end -->
     </section>
     <!-- tap_wrap end -->
     <form action="#" method="post" id='comPensationInfoForm'
      enctype="multipart/form-data">
      <aside class="title_line">
       <!-- title_line start -->
       <h3>
        <spring:message code='service.title.General' />
       </h3>
      </aside>
      <!-- title_line end -->
      <table class="type1">
       <!-- table start -->
       <caption>table</caption>
       <colgroup>
        <col style="width: 150px" />
        <col style="width: *" />
        <col style="width: 150px" />
        <col style="width: *" />
        <!-- <col style="width: 165px" />
        <col style="width: *" />
        <col style="width: 165px" />
        <col style="width: *" /> -->
       </colgroup>
       <tbody>
        <tr>
         <th scope="row"><spring:message code='service.text.AsRqstDt' /><span id='m1' name='m1' class='must'> *</span></th>
         <td>
          <input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" name="asRqstDt" id="asRqstDt"
          class="j_date" onchange="setTimeout(fn_cmpDt, 500);" />
         </td>
         <th scope="row"><spring:message code='service.grid.CompDt' /><span id='m2' name='m2' class='must'> *</span></th>
         <td>
          <input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" name="compDt" id="compDt"
          class="j_date" />
         </td>

         <!-- <th scope="row">Application Route</th>
         <td colspan="3"><input type="text" title=""
          id="asReqsterTypeId" name="asReqsterTypeId" placeholder=""
          class=" " style="width: 157px;" /></td>  -->

        </tr>
        <tr>
         <th scope="row"><spring:message code='service.grid.ASNo' /><span id='m14' name='m14' class='must'> *</span></th>
         <td><input type="text" title="" id="asNo"
          name="asNo" placeholder="<spring:message code='service.grid.ASNo' />" class=" " disabled />
          <p class="btn_sky" id="rbt">
          <a href="#" onclick="javascript :fn_doClear()"><spring:message code='service.btn.Clear' /></a>
         </p>
         <span  style="color:red;display: inline-block; margin-top: 5px;"> Choose AS No. from After Service Tab above. </span></td>
         <th scope="row"><spring:message code='service.grid.ASRs' /><span id='m15' name='m15' class='must'> *</span></th>
         <td><input type="text" title="" id="asrNo"
          name="asrNo" placeholder="<spring:message code='service.grid.ASRs' />" class=" " disabled />
          </td>
        <tr>
         <th scope="row"><spring:message code='service.text.Status' /><span id='m3' name='m3' class='must'> *</span></th>
         <td><select class="multy_select w100p"
          id="stusCodeId" name="stusCodeId">
           <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
           <c:forEach var="list" items="${cpsStatus}"
            varStatus="status">
            <option value="${list.codeId}">${list.codeName }</option>
           </c:forEach>
         </select></td>
         <th scope="row"><spring:message code='service.text.CpsAmt' /><span id='m4' name='m4' class='must'> *</span></th>
         <td><input type="text" title=""
          id="compTotAmt" name="compTotAmt" placeholder="<spring:message code='service.text.CpsAmt' />" class=" " onkeypress="return isNumberKey(event,this)" /></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.text.MngtDept' /><span id='m5' name='m5' class='must'> *</span></th>
         <td><select class="w100p"
          id="searchdepartment" name="searchdepartment" disabled>
           <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
           <c:forEach var="list" items="${mainDeptList}"
            varStatus="status">
            <c:choose>
             <c:when test="${list.codeId=='2862'}">
              <option value="${list.codeId}" selected>${list.codeName}</option>
             </c:when>
             <c:otherwise>
              <option value="${list.codeId}">${list.codeName}</option>
             </c:otherwise>
            </c:choose>
           </c:forEach>
         </select>
         </td>
         <th scope="row"><spring:message code='service.grid.RespTyp' /><span id='m6' name='m6' class='must'> *</span></th>
         <td><select id="inChrDept" name="inChrDept"
          class="w100p">
           <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
           <c:forEach var="list" items="${mainDeptList}"
            varStatus="status">
            <option value="${list.codeId}">${list.codeName }</option>
           </c:forEach>
         </select></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.grid.Branch' /><span id='m7' name='m7' class='must'> *</span></th>
         <td><select id="branchCde" name="branchCde" class="w100p">
           <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
           <c:forEach var="list" items="${branchWithNMList}"
            varStatus="status">
            <option value="${list.codeId}">${list.codeName }</option>
           </c:forEach>
         </select></td>
         <th scope="row"></th>
         <td></td>
        </tr>
       </tbody>
      </table>
      <!-- table end -->
      <aside class="title_line">
       <!-- title_line start -->
       <h3>
        <spring:message code='service.title.Details' />
       </h3>
      </aside>
      <!-- title_line end -->
      <table class="type1">
       <!-- table start -->
       <caption>table</caption>
       <colgroup>
        <col style="width: 150px" />
        <col style="width: *" />
        <col style="width: 150px" />
        <col style="width: *" />
        <!-- <col style="width: 165px" />
        <col style="width: *" />
        <col style="width: 165px" />
        <col style="width: *" /> -->
       </colgroup>
       <tbody>
        <tr>
         <th scope="row"><spring:message code='service.grid.ReqstDt' /><span id='m8' name='m8' class='must'> *</span></th>
         <td>
          <input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" name="issueDt" id="issueDt"
          class="j_date" " onchange="setTimeout(fn_cmpDt, 500);"/>
         </td>
         <th scope="row"></th>
         <td></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.text.DfctPrt' /><span id='m9' name='m9' class='must'> *</span></th>
         <td>
          <select id="dfctPrt" name="dfctPrt"
          class="w100p">
           <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
           <c:forEach var="list" items="${cpsDftTyp}"
            varStatus="status">
            <option value="${list.codeId}">${list.codeName }</option>
           </c:forEach>
         </select>
         </td>
         <th scope="row"><spring:message code='service.grid.EvtTyp' /><span id='m10' name='m10' class='must'> *</span></th>
         <td><select id="evtTyp" name="evtTyp" class="w100p">
           <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
           <c:forEach var="list" items="${cpsEvtTyp}"
            varStatus="status">
            <option value="${list.codeId}">${list.codeName }</option>
           </c:forEach>
         </select></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.text.SolutionMtd' /><span id='m11' name='m11' class='must'> *</span></th>
         <td><select id="solutionMtd" name="solutionMtd" class="w100p">
           <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
           <c:forEach var="list" items="${cpsRespTyp}"
            varStatus="status">
            <option value="${list.codeId}">${list.codeName }</option>
           </c:forEach>
         </select></td>
         <th scope="row"><spring:message code='service.grid.Cause' /><span id='m12' name='m12' class='must'> *</span></th>
         <td><select id="cause" name="cause" class="w100p">
           <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
           <c:forEach var="list" items="${cpsCocTyp}"
            varStatus="status">
            <option value="${list.codeId}">${list.codeName }</option>
           </c:forEach>
         </select></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.grid.CpsTyp' /><span id='m13' name='m13' class='must'> *</span></th>
         <td><select id="cpsTyp" name="cpsTyp" class="w100p">
           <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
           <c:forEach var="list" items="${cpsTyp}"
            varStatus="status">
            <option value="${list.codeId}">${list.codeName }</option>
           </c:forEach>
         </select></td>
         <th scope="row"></th>
         <td><input type="text" title="" id="CpsTypRsn"
          name="CpsTypRsn" placeholder="" class=" " disabled /></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.grid.CpsItm' /></th>
         <td colspan="3"><textarea class="w100p" rows="3" style="height:auto" id=cpsItm name="cpsItm"/></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.Remark' /></th>
         <td colspan="3"><textarea class="w100p" rows="2" style="height:auto" id="rmk" name="rmk"/></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='budget.Attathment' /></th>
         <td colspan="3">
          <div class="auto_file2 attachment_file w100p">
           <!-- auto_file start -->
           <input type="file" title="file add" style="width: 300px" />
          </div> <!-- auto_file end -->
         </td>
        </tr>
       </tbody>
      </table>
      <input type="hidden" title="" id="custId" name="custId" placeholder="" class=" " value= "${orderDetail.basicInfo.custId}" />
      <input type="hidden" title="" id="ordId" name="ordId" placeholder="" class=" " value= "${orderDetail.basicInfo.ordId}" />
      <input type="hidden" title="" id="asNoHid" name="asNoHid" placeholder="" class=" "  />
      <input type="hidden" title="" id="asrNoHid" name="asrNoHid" placeholder="" class=" " />
      <!-- REPORT PARAM -->
      <input type="hidden" title="" id="reportFileName" name="reportFileName" placeholder="" class=" " />
      <input type="hidden" title="" id="viewType" name="viewType" placeholder="" class=" " />
      <input type="hidden" title="" id="V_SELECTSQL" name="V_SELECTSQL" placeholder="" class=" " />
      <input type="hidden" title="" id="V_WHERESQL" name="V_WHERESQL" placeholder="" class=" " />
      <input type="hidden" title="" id="V_GROUPBYSQL" name="V_GROUPBYSQL" placeholder="" class=" " />
      <input type="hidden" title="" id="V_FULLSQL" name="V_FULLSQL" placeholder="" class=" " />
      <input type="hidden" title="" id="V_ASNOFORM" name="V_ASNOFORM" placeholder="" class=" " />
      <input type="hidden" title="" id="V_ASNOTO" name="V_ASNOTO" placeholder="" class=" " />
      <input type="hidden" title="" id="V_ASRNOFROM" name="V_ASRNOFROM" placeholder="" class=" " />
      <input type="hidden" title="" id="V_ASRNOTO" name="V_ASRNOTO" placeholder="" class=" " />
      <input type="hidden" title="" id="V_CTCODE" name="V_CTCODE" placeholder="" class=" " />
      <input type="hidden" title="" id="V_DSCCODE" name="V_DSCCODE" placeholder="" class=" " />
      <input type="hidden" title="" id="V_REQUESTDATEFROM" name="V_REQUESTDATEFROM" placeholder="" class=" " />
      <input type="hidden" title="" id="V_REQUESTDATETO" name="V_REQUESTDATETO" placeholder="" class=" " />
      <input type="hidden" title="" id="V_APPOINDATEFROM" name="V_APPOINDATEFROM" placeholder="" class=" " />
      <input type="hidden" title="" id="V_APPOINDATETO" name="V_APPOINDATETO" placeholder="" class=" " />
      <input type="hidden" title="" id="V_ASTYPEID" name="V_ASTYPEID" placeholder="" class=" " />
      <input type="hidden" title="" id="V_ASSTATUS" name="V_ASSTATUS" placeholder="" class=" " />
      <input type="hidden" title="" id="V_ASGROUP" name="V_ASGROUP" placeholder="" class=" " />
      <input type="hidden" title="" id="V_ORDNUMTO" name="V_ORDNUMTO" placeholder="" class=" " />
      <input type="hidden" title="" id="V_ORDNUMFR" name="V_ORDNUMFR" placeholder="" class=" " />
      <input type="hidden" title="" id="V_ASTEMPSORT" name="V_ASTEMPSORT" placeholder="" class=" " />
      <!-- table end -->
     </form>
     <ul class="center_btns" id='save_bt_div'>
      <li><p class="btn_blue2 big">
        <a href="#" onClick="fn_doSave()"><spring:message
          code='service.btn.Save' /></a>
       </p></li>

     </ul>
    </section>
    <!-- search_result end -->
   </div>
   <!-- pop_body end -->
 </div>
 <!-- popup_wrap end -->
</body>