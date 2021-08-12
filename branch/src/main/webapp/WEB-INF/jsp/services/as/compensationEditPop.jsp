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
      var statusCd = "${compensationView.stusCodeId}";
      $("#cpsEdtForm #stusCodeId option[value='" + statusCd + "']").attr("selected", true);

      var searchdepartmentStatusCd = "${compensationView.cspItmOth}";
      $("#cpsEdtForm #searchdepartment option[value='" + searchdepartmentStatusCd + "']").attr("selected", true);

      var inChrDept = "${compensationView.inChrDept}";
      $("#cpsEdtForm #inChrDept option[value='" + inChrDept + "']").attr("selected", true);

      var branchCde = "${compensationView.branchCde}";
      $("#cpsEdtForm #branchCde option[value='" + branchCde + "']").attr("selected", true);

      var dfctPrt = "${compensationView.dfctPrt}";
      $("#cpsEdtForm #dfctPrt option[value='" + dfctPrt + "']").attr("selected", true);

      var evtTyp = "${compensationView.evtTyp}";
      $("#cpsEdtForm #evtTyp option[value='" + evtTyp + "']").attr("selected", true);

      var cause = "${compensationView.cause}";
      $("#cpsEdtForm #cause option[value='" + cause + "']").attr("selected", true);

      var solutionMtd = "${compensationView.solutionMtd}";
      $("#cpsEdtForm #solutionMtd option[value='" + solutionMtd + "']").attr("selected", true);

      var cspTypId = "${compensationView.cspTypId}";
      $("#cpsEdtForm #cpsTyp option[value='" + cspTypId + "']").attr("selected", true);

      AUIGrid.resize(asHistoryGrid, 1000, 300);
      AUIGrid.resize(bsHistoryGrid, 1000, 300);

      createASHistoryGrid();
      createBSHistoryGrid();

      fn_getASHistoryInfo();
      fn_getBSHistoryInfo();

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

      /*AttachFile values*/
      $("input[name=attachFile]").on("dblclick",
        function() {
          Common.showLoader();

          var $this = $(this);
          var fileId = $this.attr("data-id");

          $.fileDownload("${pageContext.request.contextPath}/file/fileDown.do",
            { httpMethod : "POST",
              contentType : "application/json;charset=UTF-8",
              data : {
                fileId : fileId
              },
              failCallback : function(
                responseHtml,
                url,
                error) {
                  Common.alert($(responseHtml).find("#errorMessage").text());
                }
            }).done( function() {
              Common.removeLoader();
              console.log('File download a success!');
            }).fail(function() {
              Common.removeLoader();
            });
              return false; //this is critical to stop the click event which will trigger a normal file download
          });
        });

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
    $("#_compensationEditPop").remove();
  }

  function fn_doSave() {
    if (!fn_cmpDt()) {
      return;
    }
    if (!fn_validate_field()) {
      return;
    }

    var formData = Common.getFormData("cpsEdtForm");

    formData.append("compNo", $("#cpsNo").val());
    formData.append("crtUserId", $("#crtUserId").val());
    formData.append("fileGroupId", $("#fileGroupId").val());
    formData.append("updateFileIds", $("#updateFileIds").val());
    formData.append("deleteFileIds", $("#deleteFileIds").val());

    var obj = $("#cpsEdtForm").serializeJSON();

    $.each(obj, function(key, value) {
      formData.append(key, value);
    });

    Common.ajaxFile("/services/compensation/updateCompensation.do", formData, function(result) {
      Common.alert(result.message);
      fn_searchASManagement();
      $("#_compensationEditPop").remove();
    });
  }

  function fn_validate_field() {
    var msg = "";
    var field = "";

    if ($("#cpsEdtForm #stusCodeId").val() == "" || $("#cpsEdtForm #stusCodeId").val() == null) {
      field = "<spring:message code='service.text.Status' />";
      msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
      field = "";
    }

    if ($("#cpsEdtForm #stusCodeId").val() == "34" || $("#cpsEdtForm #stusCodeId").val() == "35") { // SOLVED / UNSOLVED
      if ($("#cpsEdtForm #asRqstDt").val() == "" || $("#cpsEdtForm #asRqstDt").val() == null) {
        field = "<spring:message code='service.text.AsRqstDt' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #compDt").val() == "" || $("#cpsEdtForm #compDt").val() == null) {
        field = "<spring:message code='service.grid.CompDt' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #asNoHid").val() == "" || $("#cpsEdtForm #asNoHid").val() == null) {
        field = "<spring:message code='service.grid.ASNo' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #asrNoHid").val() == "" || $("#cpsEdtForm #asrNoHid").val() == null) {
        field = "<spring:message code='service.grid.ASRs' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #stusCodeId").val() == "" || $("#cpsEdtForm #stusCodeId").val() == null) {
        field = "<spring:message code='service.text.Status' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #compTotAmt").val() == "" || $("#cpsEdtForm #compTotAmt").val() == null) {
        field = "<spring:message code='service.text.CpsAmt' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #searchdepartment").val() == "" || $("#cpsEdtForm #searchdepartment").val() == null) {
        field = "<spring:message code='service.text.MngtDept' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #inChrDept").val() == "" || $("#cpsEdtForm #inChrDept").val() == null) {
        field = "<spring:message code='service.text.InChrDept' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #branchCde").val() == "" || $("#cpsEdtForm #branchCde").val() == null) {
        field = "<spring:message code='service.grid.Branch' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #issueDt").val() == "" || $("#cpsEdtForm #issueDt").val() == null) {
        field = "<spring:message code='service.text.IssueDt' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #dfctPrt").val() == "" || $("#cpsEdtForm #dfctPrt").val() == null) {
        field = "<spring:message code='service.text.DfctPrt' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #evtTyp").val() == "" || $("#cpsEdtForm #evtTyp").val() == null) {
        field = "<spring:message code='service.grid.EvtTyp' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #solutionMtd").val() == "" || $("#cpsEdtForm #solutionMtd").val() == null) {
        field = "<spring:message code='service.text.SolutionMtd' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #cause").val() == "" || $("#cpsEdtForm #cause").val() == null) {
        field = "<spring:message code='service.grid.Cause' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #cpsTyp").val() == "" || $("#cpsEdtForm #cpsTyp").val() == null) {
        field = "<spring:message code='service.grid.CpsTyp' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
    } else if ($("#cpsEdtForm #stusCodeId").val() == "1" || $("#cpsEdtForm #stusCodeId").val() == "44") {
      if ($("#cpsEdtForm #asRqstDt").val() == "" || $("#cpsEdtForm #asRqstDt").val() == null) {
        field = "<spring:message code='service.text.AsRqstDt' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #stusCodeId").val() == "" || $("#cpsEdtForm #stusCodeId").val() == null) {
        field = "<spring:message code='service.text.Status' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
    } else if ($("#cpsEdtForm #stusCodeId").val() == "10" || $("#cpsEdtForm #stusCodeId").val() == "36") {
      if ($("#cpsEdtForm #asRqstDt").val() == "" || $("#cpsEdtForm #asRqstDt").val() == null) {
        field = "<spring:message code='service.text.AsRqstDt' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #compDt").val() == "" || $("#cpsEdtForm #compDt").val() == null) {
        field = "<spring:message code='service.grid.CompDt' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #stusCodeId").val() == "" || $("#cpsEdtForm #stusCodeId").val() == null) {
        field = "<sprng:message code='service.text.Status' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #searchdepartment").val() == "" || $("#cpsEdtForm #searchdepartment").val() == null) {
        field = "<spring:message code='service.text.MngtDept' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #inChrDept").val() == "" || $("#cpsEdtForm #inChrDept").val() == null) {
        field = "<spring:message code='service.text.InChrDept' />";
        msg = msg + "<b>* <spring:message code='sys.msg.necessary' arguments= '" + field + "' htmlEscape='false'/></b><br/>" ;
        field = "";
      }
      if ($("#cpsEdtForm #branchCde").val() == "" || $("#cpsEdtForm #branchCde").val() == null) {
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

  function fn_abstractChangeFile(thisfakeInput) {
    if (FormUtil.isNotEmpty(thisfakeInput.attr("data-id"))) {
      var updateFileIds = $("#cpsEdtForm #updateFileIds").val();
      $("#cpsEdtForm #updateFileIds").val(thisfakeInput.attr("data-id") + DEFAULT_DELIMITER + updateFileIds);
    }
  }

  function fn_abstractDeleteFile(thisfakeInput) {
    if (FormUtil.isNotEmpty(thisfakeInput.attr("data-id"))) {
      var deleteFileIds = $("#cpsEdtForm #deleteFileIds").val();
      $("#cpsEdtForm #deleteFileIds").val(thisfakeInput.attr("data-id") + DEFAULT_DELIMITER + deleteFileIds);
    }
  }

  function fn_doClear() {
    $("#cpsEdtForm #asNo").val("");
    $("#cpsEdtForm #asrNo").val("");

    $("#cpsEdtForm #asNoHid").val("");
    $("#cpsEdtForm #asrNoHid").val("");
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
    $("#cpsEdtForm #reportFileName").val('/services/ASSummaryList.rpt');
    $("#cpsEdtForm #reportDownFileName").val("ASSummaryList_" + day + month + date.getFullYear() + "_" + ordNo);
    $("#cpsEdtForm #viewType").val("PDF");
    $("#cpsEdtForm #V_SELECTSQL").val();
    $("#cpsEdtForm #V_WHERESQL").val(whereSql);
    $("#cpsEdtForm #V_GROUPBYSQL").val();
    $("#cpsEdtForm #V_FULLSQL").val();
    $("#cpsEdtForm #V_ASNOFORM").val();
    $("#cpsEdtForm #V_ASNOTO").val();
    $("#cpsEdtForm #V_ASRNOFROM").val();
    $("#cpsEdtForm #V_ASRNOTO").val();
    $("#cpsEdtForm #V_CTCODE").val();
    $("#cpsEdtForm #V_DSCCODE").val();
    $("#cpsEdtForm #V_REQUESTDATEFROM").val();
    $("#cpsEdtForm #V_REQUESTDATETO").val();
    $("#cpsEdtForm #V_APPOINDATEFROM").val();
    $("#cpsEdtForm #V_APPOINDATETO").val();
    $("#cpsEdtForm #V_ASTYPEID").val();
    $("#cpsEdtForm #V_ASSTATUS").val();
    $("#cpsEdtForm #V_ASGROUP").val();
    $("#cpsEdtForm #V_ASTEMPSORT").val();
    $("#cpsEdtForm #V_ORDNUMTO").val(ordNo);
    $("#cpsEdtForm #V_ORDNUMFR").val(ordNo);

    var option = {
      isProcedure : true,
    };

    Common.report("cpsEdtForm", option);
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
   <h1>Edit Compensation Log Detail</h1>
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
     <form action="#" method="post" id='cpsEdtForm'
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
          class="j_date" value="${compensationView.asRqstDt}"  onchange="setTimeout(fn_cmpDt, 500);"/>
         </td>
         <th scope="row"><spring:message code='service.grid.CompDt' /><span id='m2' name='m2' class='must'> *</span></th>
         <td>
          <input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" name="compDt" id="compDt"
          class="j_date" value="${compensationView.compDt}"/>
         </td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.grid.ASNo' /><span id='m14' name='m14' class='must'> *</span></th>
         <td><input type="text" title="" id="asNo"
          name="asNo" placeholder="<spring:message code='service.grid.ASNo' />" class=" " disabled value="${compensationView.asNo}" />
          <p class="btn_sky" id="rbt">
          <a href="#" onclick="fn_doClear()"><spring:message code='service.btn.Clear' /></a>
         </p>
         <span  style="color:red;display: inline-block; margin-top: 5px;"> Choose AS No. from After Service Tab above. </span></td>
         <th scope="row"><spring:message code='service.grid.ASRs' /><span id='m15' name='m15' class='must'> *</span></th>
         <td><input type="text" title="" id="asrNo"
          name="asrNo" placeholder="<spring:message code='service.grid.ASRs' />" class=" " disabled value="${compensationView.asrNo}" />
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
          id="compTotAmt" name="compTotAmt" placeholder="<spring:message code='service.text.CpsAmt' />" class=" " onkeypress="return isNumberKey(event,this)" value="${compensationView.cspAmt}" /></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.text.MngtDept' /><span id='m5' name='m5' class='must'> *</span></th>
         <td><select class="w100p"
          id="searchdepartment" name="searchdepartment" disabled>
           <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
           <c:forEach var="list" items="${mainDeptList}"
            varStatus="status1">
            <option value="${list.codeId}">${list.codeName }</option>
           </c:forEach>
         </select>
         </td>
         <th scope="row"><spring:message code='service.grid.RespTyp' /><span id='m6' name='m6' class='must'> *</span></th>
         <td><select id="inChrDept" name="inChrDept"
          class="w100p">
           <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
           <c:forEach var="list" items="${mainDeptList}"
            varStatus="status2">
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
          class="j_date" value="${compensationView.issueDt}" onchange="setTimeout(fn_cmpDt, 500);"/>
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
         <td colspan="3"><textarea class="w100p" rows="3" style="height:auto" id=cspItm name="cspItm">${compensationView.cspItm}</textarea></td>
        </tr>
        <tr>
         <th scope="row"><spring:message code='service.title.Remark' /></th>
         <td colspan="3"><textarea class="w100p" rows="2" style="height:auto" id="rmk" name="rmk">${compensationView.cspRmk}</textarea></td>
        </tr>
        <tr>
       <th scope="row"><spring:message code='budget.Attathment' /></br ><span style="color:red;display: inline-block; margin-top: 5px; margin-bottom: 5px;"> Double click <br> file name to download. <br> </span></th>
       <td colspan="3">
        <c:forEach var="fileInfo" items="${files}" varStatus="status">
          <div class="auto_file2"><!-- auto_file start -->
            <input title="file add" style="width: 300px;" type="file">
              <label>
                <input type='text' class='input_text' readonly='readonly' name="attachFile" value="${fileInfo.atchFileName}" data-id="${fileInfo.atchFileId}"/>
                <span class='label_text'><a href='#' disabled><spring:message code='commission.text.search.file' /></a></span>
              </label>
              <span class='label_text'><a href='#'><spring:message code='sys.btn.add' /></a></span>
              <span class='label_text'><a href='#'><spring:message code='sys.btn.delete' /></a></span>
            </div>
       </c:forEach>
       <div class="auto_file2"><!-- auto_file start -->
         <input title="file add" style="width: 300px;" type="file"/>
         <label>
            <input type='text' class='input_text' readonly='readonly' value="" data-id=""/>
            <span class='label_text'><a href='#'><spring:message code='commission.text.search.file' /></a></span>
        </label>
        <span class='label_text'><a href='#'><spring:message code='sys.btn.add' /></a></span>
        <span class='label_text'><a href='#'><spring:message code='sys.btn.delete' /></a></span>
       </div>
       </td>
      </tr>
       </tbody>
      </table>
      <input type="hidden" title="" id="custId" name="custId" placeholder="" class=" " value= "${orderDetail.basicInfo.custId}" />
      <input type="hidden" title="" id="ordId" name="ordId" placeholder="" class=" " value= "${orderDetail.basicInfo.ordId}" />
      <input type="hidden" title="" id="asNoHid" name="asNoHid" placeholder="" class=" " value="${compensationView.asNo}" />
      <input type="hidden" title="" id="asrNoHid" name="asrNoHid" placeholder="" class=" " value="${compensationView.asrNo}" />
      <input type="hidden" name=cpsNo id="cpsNo" value="${compensationView.cpsNo}" />
      <input type="hidden" id="fileGroupId" name="fileGroupId" value="${compensationView.atchFileGrpId}">
      <input type="hidden" id="updateFileIds" name="updateFileIds" value="">
      <input type="hidden" id="deleteFileIds" name="deleteFileIds" value="">
      <input type="hidden" id="crtUserId" name="crtUserId" value="${compensationView.crtUserId}">
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