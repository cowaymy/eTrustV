<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.right-column {
  text-align: right;
  margin-top: -20px;
}

.l0-style {
    background:#92BCCA;
    font-weight:bold;
}

.l1-style {
    background:#96D2E6;
    font-weight:bold;
}

.l2-style {
    background:#C4DEE6;
    font-weight:bold;
}

.l3-style {
    background:#ADD8E6;
    font-weight:bold;
}

</style>

</style>
<script type="text/javaScript">
  var myGridID2,excelGridID;
  var memCode;
  var today = "${today}";
  var userDefine1 = "${PAGE_AUTH.funcUserDefine1}";
  var userDefine2 = "${PAGE_AUTH.funcUserDefine2}";
  var MEM_TYPE = "${memCodeType}";

  $(document).ready( function() {
            createAUIGrid();
            AUIGrid.setSelectionMode(myGridID2, "singleRow");

            if ("${SESSION_INFO.userTypeId}" != 1 && "${SESSION_INFO.userTypeId}" != 2) {
              $("#typeCode").prop("disabled", false);
            }

            if(MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7" ){

                if("${SESSION_INFO.memberLevel}" =="1"){

                    $("#orgCode").val("${orgCode}");
                    $("#orgCode").attr("class", "w100p readonly");
                    $("#orgCode").attr("readonly", "readonly");

                }else if("${SESSION_INFO.memberLevel}" =="2"){

                    $("#orgCode").val("${orgCode}");
                    $("#orgCode").attr("class", "w100p readonly");
                    $("#orgCode").attr("readonly", "readonly");

                    $("#grpCode").val("${grpCode}");
                    $("#grpCode").attr("class", "w100p readonly");
                    $("#grpCode").attr("readonly", "readonly");

                }else if("${SESSION_INFO.memberLevel}" =="3"){

                    $("#orgCode").val("${orgCode}");
                    $("#orgCode").attr("class", "w100p readonly");
                    $("#orgCode").attr("readonly", "readonly");

                    $("#grpCode").val("${grpCode}");
                    $("#grpCode").attr("class", "w100p readonly");
                    $("#grpCode").attr("readonly", "readonly");

                    $("#deptCode").val("${deptCode}");
                    $("#deptCode").attr("class", "w100p readonly");
                    $("#deptCode").attr("readonly", "readonly");

                }else if("${SESSION_INFO.memberLevel}" =="4"){

                    $("#orgCode").val("${orgCode}");
                    $("#orgCode").attr("class", "w100p readonly");
                    $("#orgCode").attr("readonly", "readonly");

                    $("#grpCode").val("${grpCode}");
                    $("#grpCode").attr("class", "w100p readonly");
                    $("#grpCode").attr("readonly", "readonly");

                    $("#deptCode").val("${deptCode}");
                    $("#deptCode").attr("class", "w100p readonly");
                    $("#deptCode").attr("readonly", "readonly");

                    $("#memCode").val("${SESSION_INFO.userName}");
                    $("#memCode").attr("class", "w100p readonly");
                    $("#memCode").attr("readonly", "readonly");
                    $("#_memBtn").hide();

                }
            }

            $("#search").click(function() {
                      var valid = false;

                      var d = new Date();
                      var h = d.getDate();
                      var i = d.getHours();
                      if(h == 30){
                          if(8 < i && i < 15){
                              Common.alert("This page cannot be search on 1st day of every month from 9am - 3pm");
                              return;
                          }

                      }

                      if (valid) {
                        Common.alert("<spring:message code='commission.alert.SHIIndex.member.noSelect'/>");
                        $("#teamCode").val("");
                        $("#level").val("");
                      } else {
                        $("#typeCode").prop("disabled",false);

                        Common.ajax("GET","/commission/report/commSHIMemSearch",$("#myForm").serializeJSON(),function(result) {
                                  if (result != null) {
                                    $("#teamCode").val(result.DEPT_CODE);
                                    $("#level").val(result.MEM_LVL);

                                    if(!$("#orgCode").val()) $("#orgCode").val(result.ORG_CODE);
                                    if(!$("#grpCode").val()) $("#grpCode").val(result.GRP_CODE);
                                    if(!$("#deptCode").val()) $("#deptCode").val(result.DEPT_CODE);

                                    Common.ajaxSync("GET","/commission/report/commSPCRgenrawSHIIndex",$("#myForm").serializeJSON(),function(result) {
                                        //$("#typeCode").prop("disabled",true);

                                        AUIGrid.setProp(myGridID2, "rowStyleFunction", function(rowIndex, item){
                                            if (item.topOrgCode)
                                                return "l0-style";
                                            if (item.orgCode)
                                                return "l1-style";
                                            if (item.grpCode)
                                                return "l2-style";
                                            if (item.deptCode)
                                                return "l3-style";
                                        });

                                        AUIGrid.setGridData(myGridID2,result);
                                        AUIGrid.setGridData(excelGridID,result);
                                      });
                                  } else {
                                    Common.alert("<spring:message code='commission.alert.SHIIndex.member.noFound'/>");
                                    if (userDefine2 == "Y") {
                                      $("#memCode").val("");
                                      $("#teamCode").val("");
                                      $("#level").val("");
                                    }
                                  }

                                });
                      }
                    });


            $('#memBtn').click(
                function() {
                  Common.popupDiv("/common/memberPop.do", $("#myForm").serializeJSON(), null,true);
                });

            AUIGrid.bind(myGridID2,"cellDoubleClick",function(event) {
                      /* memCode = null;
                      if (AUIGrid.getCellValue(myGridID2, event.rowIndex, "memCode") != null && AUIGrid.getCellValue(myGridID2,event.rowIndex,"memCode") != "") {
                        memCode = AUIGrid.getCellValue(myGridID2,event.rowIndex,"memCode");
                        var date = {
                          "memCode" : memCode,
                          "searchDt" : $("#shiDate").val()
                        };
                        Common.popupDiv("/commission/report/commSHIIndexViewDetailsPop.do",date);
                      } */

                      let data = {
                    		catType  : $("#catType").val(),
                            custType : $("#custType").val(),
                            shiDate  : $("#shiDate").val(),
                            typeCode : $("#typeCode").val()
                      };

                      let level = 4;
                      let teamCode = "";

                      if (event.item.topOrgCode){
                    	  level = 0;
                    	  teamCode = event.item.topOrgCode;
                      }
                      if (event.item.orgCode){
                    	  level = 1;
                          teamCode = event.item.orgCode;
                      }
                      if (event.item.grpCode){
                    	  level = 2;
                    	  teamCode = event.item.grpCode;
                      }
                      if (event.item.deptCode){
                    	  level = 3;
                    	  teamCode = event.item.deptCode;
                      }

                      data["teamCode"] = teamCode;
                      data["level"]    = level;
                      data["memCode"]  = event.item.memCode;

                      if($('#level').val() <= level){
                    	  Common.popupDiv("/commission/report/commSHIIndexViewDetailsPop.do", data);
                      }
                    });

            $("#clear").click(function() {
              document.myForm.reset();

              if(MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7" ){

                  if("${SESSION_INFO.memberLevel}" =="1"){

                      $("#orgCode").val("${orgCode}");
                      $("#orgCode").attr("class", "w100p readonly");
                      $("#orgCode").attr("readonly", "readonly");

                  }else if("${SESSION_INFO.memberLevel}" =="2"){

                      $("#orgCode").val("${orgCode}");
                      $("#orgCode").attr("class", "w100p readonly");
                      $("#orgCode").attr("readonly", "readonly");

                      $("#grpCode").val("${grpCode}");
                      $("#grpCode").attr("class", "w100p readonly");
                      $("#grpCode").attr("readonly", "readonly");

                  }else if("${SESSION_INFO.memberLevel}" =="3"){

                      $("#orgCode").val("${orgCode}");
                      $("#orgCode").attr("class", "w100p readonly");
                      $("#orgCode").attr("readonly", "readonly");

                      $("#grpCode").val("${grpCode}");
                      $("#grpCode").attr("class", "w100p readonly");
                      $("#grpCode").attr("readonly", "readonly");

                      $("#deptCode").val("${deptCode}");
                      $("#deptCode").attr("class", "w100p readonly");
                      $("#deptCode").attr("readonly", "readonly");

                  }else if("${SESSION_INFO.memberLevel}" =="4"){

                      $("#orgCode").val("${orgCode}");
                      $("#orgCode").attr("class", "w100p readonly");
                      $("#orgCode").attr("readonly", "readonly");

                      $("#grpCode").val("${grpCode}");
                      $("#grpCode").attr("class", "w100p readonly");
                      $("#grpCode").attr("readonly", "readonly");

                      $("#deptCode").val("${deptCode}");
                      $("#deptCode").attr("class", "w100p readonly");
                      $("#deptCode").attr("readonly", "readonly");

                      $("#memCode").val("${SESSION_INFO.userName}");
                      $("#memCode").attr("class", "w100p readonly");
                      $("#memCode").attr("readonly", "readonly");
                      $("#_memBtn").hide();

                  }
              }

            });

            $("#generate").click(function() {
                      let valid = AUIGrid.getRowCount(myGridID2);

                      if (valid <= 0) {
                        Common.alert("<spring:message code='commission.alert.SHIIndex.member.noSelect'/>");
                      } else {

                        var date = $("#shiDate").val();
                        var month = Number(date.substring(0, 2));
                        if (month < 10) {
                          month = "0" + month;
                        }
                        var year = Number(date.substring(3));
                        var memCd = $("#memCode").val();
                        var typeCode = $("#typeCode").val();
                        var teamCode = $("#deptCode").val();
                        var level = $("#level").val();
                        let grpCode = $("#grpCode").val();
                        let orgCode = $("#orgCode").val();

                        var custType = $("#custType").val();
                        var catType = $("#catType").val();

                        var reportFileName = "/commission/SHIIndexExcelRaw.rpt"; //reportFileName
                        var reportDownFileName = "SHIIndexExcelFile_" + today; //report name
                        var reportViewType = "EXCEL"; //viewType

                        $("#reportForm #mCode").val(memCd);
                        $("#reportForm #month").val(month);
                        $("#reportForm #year").val(year);
                        $("#reportForm #mLvl").val(level);
                        $("#reportForm #mType").val(typeCode);
                        $("#reportForm #rptDeptCode").val(teamCode);
                        $("#reportForm #rptCustType").val(custType);
                        $("#reportForm #rptCatType").val(catType);
                        $("#reportForm #rptGrpCode").val(grpCode);
                        $("#reportForm #rptOrgCode").val(orgCode);

                        $("#reportForm #reportFileName").val(reportFileName);
                        $("#reportForm #reportDownFileName").val(reportDownFileName);
                        $("#reportForm #viewType").val(reportViewType);

                        //  report 호출
                        var option = {
                          isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                        };

                        Common.report("reportForm",option);
                      }
                    });

                $('#excelDown').click(function() {
                    AUIGrid.exportToXlsx(excelGridID);
                });

          });

  function createAUIGrid() {
    var columnLayout3 = [
        {
          dataField : "topOrgCode",
          headerText : "<spring:message code='commission.text.grid.topOrgCode'/>",
          editable : false
        },
        {
          dataField : "orgCode",
          headerText : "<spring:message code='commission.text.grid.orgCode'/>",
          editable : false
        },
        {
          dataField : "grpCode",
          headerText : "<spring:message code='commission.text.grid.grpCode'/>",
          editable : false
        },
        {
          dataField : "deptCode",
          headerText : "<spring:message code='commissiom.text.excel.deptCd'/>",
          editable : false
        },
        {
          dataField : "memCode",
          headerText : "<spring:message code='commission.text.search.memCode'/>",
          editable : false
        },
        {
          dataField : "unit",
          headerText : "<spring:message code='commission.text.grid.unit'/>",
          style : "right-column",
          editable : false
        },
        {
          dataField : "targetatmt",
          headerText : "<spring:message code='commission.text.grid.target'/>",
          style : "right-column",
          dataType: "numeric",
          formatString : "#,##0.00",
          editable : false
        },
        {
          dataField : "collectamt",
          headerText : "<spring:message code='commission.text.grid.currentCollection'/>",
          style : "right-column",
          dataType: "numeric",
          formatString : "#,##0.00",
          editable : false
        },
        {
          dataField : "collectrate",
          headerText : "<spring:message code='commission.text.grid.collectionRate'/>",
          style : "right-column",
          dataType: "numeric",
          formatString : "#,##0.00",
          editable : false
        } ];
    // 그리드 속성 설정
    var gridPros = {

      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
      headerHeight : 40

    };

    myGridID2 = AUIGrid.create("#grid_wrap", columnLayout3, gridPros);

    var excelGridPros = {
            enterKeyColumnBase : true,
            useContextMenu : true,
            enableFilter : true,
            showStateColumn : true,
            displayTreeOpen : true,
            noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
            groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
            exportURL : "/common/exportGrid.do"
        };

    excelGridID = AUIGrid.create("#excel_list_grid_wrap", columnLayout3, excelGridPros);
  }

  function fn_loadOrderSalesman(memId, memCode) {
    $("#memCode").val(memCode);
  }


</script>
<section id="content">
    <!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li><spring:message code='commission.text.head.commission' /></li>
        <li><spring:message code='commission.text.head.report' /></li>
        <li><spring:message code='commission.text.head.shiIndex' /></li>
    </ul>
    <aside class="title_line">
    <!-- title_line start -->
        <p class="fav">
            <a href="#" class="click_add_on">My menu</a>
        </p>
        <h2>
            <spring:message code='commission.title.SHI' />
        </h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <li>
                    <p class="btn_blue"><a href="#" id="search"><spring:message code='sys.btn.search' /></a></p>
                </li>
            </c:if>
            <li>
                <p class="btn_blue">
                    <a href="#" id="clear"><span class="clear"></span>
                    <spring:message code='sys.btn.clear' /></a>
                </p>
            </li>
        </ul>
    </aside>
    <!-- title_line end -->
    <section class="search_table">
        <!-- search_table start -->
        <form name="reportForm" id="reportForm">
            <input type="hidden" name="V_MEMCODE" id="mCode" />
            <input type="hidden" name="V_PVMTH" id="month" />
            <input type="hidden" name="V_PVYEAR" id="year" />
            <input type="hidden" name="V_MEMLVL" id="mLvl" />
            <input type="hidden" name="V_MEMTYPE" id="mType" />
            <input type="hidden" name="V_DEPTCODE" id="rptDeptCode" />
            <input type="hidden" name="V_GRPCODE" id="rptGrpCode" />
            <input type="hidden" name="V_ORGCODE" id="rptOrgCode" />
            <input type="hidden" name="V_CUST_TYPE" id="rptCustType" />
            <input type="hidden" name="V_CAT_TYPE" id="rptCatType" />
            <input type="hidden" name="reportDownFileName" id="reportDownFileName" />
            <input type="hidden" name="reportFileName" id="reportFileName" />
            <input type="hidden" name="viewType" id="viewType" />
        </form>
        <form action="#" method="post" name="myForm" id="myForm">
            <table class="type1">
            <!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width: 140px" />
                    <col style="width: *" />
                    <col style="width: 140px" />
                    <col style="width: *" />
                    <col style="width: 170px" />
                    <col style="width: *" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row"><spring:message code='commission.text.search.orgType' /></th>
                        <td>
                            <select class="w100p" id="typeCode" name="typeCode" disabled>
                                <c:forEach var="list" items="${memType}">
                                    <option value="${list.cdid}" <c:if test="${list.cdid == SESSION_INFO.userTypeId}"> selected</c:if>>
                                        ${list.cdnm} (${list.cd})
                                    </option>
                                </c:forEach>
                            </select>
                        </td>
                        <th scope="row"><spring:message code='commission.text.search.memCode' /></th>
                        <td>
                            <input type="text" title="" placeholder="" id="memCode" name="memCode"
                                <%-- <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y' && PAGE_AUTH.funcUserDefine2 != 'Y'}"> value="${loginId }" readonly </c:if> --%>
                            />
                            <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
                                <a id="memBtn" href="#" class="search_btn">
                                    <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                                </a>
                            </c:if>
                        </td>
                        <th scope="row"><spring:message code='commission.text.search.commMonth' /></th>
                        <td>
                            <input type="text" title="기준년월" class="j_date2 w100p" id="shiDate" name="shiDate" value="${searchDt }" />
                        </td>
                    </tr>
                    <tr>
                        <%-- <th scope="row">* <spring:message code='commission.text.search.teamCode' /></th>
                        <td>
                            <input type="text" title="" placeholder="" class="w100p readonly" readonly="readonly" id="teamCode" name="teamCode" />
                        </td> --%>
                        <th scope="row">* <spring:message code='commission.text.search.level' /></th>
                        <td>
                            <input type="text" title="" placeholder="" class="w100p readonly" readonly="readonly" id="level" name="level" />
                        </td>
                        <th scope="row">* <spring:message code='sal.title.text.category' /></th>
                        <td>
                            <select class="w100p" id="catType" name="catType">
                                <option value="">All</option>
                                <option value="HA">HA - Home Appliances</option>
                                <option value="HC">HC - Homecare</option>
                            </select>
                        </td>
                        <th scope="row">Customer Type</th>
                        <td>
                            <select class="w100p" id="custType" name="custType">
                                <option value="964,965">All</option>
                                <option value="964">Individual</option>
                                <option value="965">Company</option>
                            </select>
                        </td>
                    </tr>
                    <%-- <tr>
                        <th scope="row">* <spring:message code='sal.title.text.category' /></th>
                        <td>
                            <select class="w100p" id="catType" name="catType">
                                <option value="">All</option>
                                <option value="HA">HA - Home Appliances</option>
                                <option value="HC">HC - Homecare</option>
                            </select>
                        </td>
                        <th scope="row"></th>
                        <td></td>
                        <th scope="row"></th>
                        <td></td>
                    </tr> --%>
                    <tr>
                        <th scope="row">Org Code</th>
                        <td><input type="text" title="orgCode" id="orgCode" name="orgCode" placeholder="Org Code" class="w100p" /></td>
                        <th scope="row">Grp Code</th>
                        <td><input type="text" title="grpCode" id="grpCode" name="grpCode"  placeholder="Grp Code" class="w100p"/></td>
                        <th scope="row">Dept Code</th>
                        <td><input type="text" title="deptCode" id="deptCode" name="deptCode"  placeholder="Dept Code" class="w100p"/></td>
                    </tr>
                    <tr>
                        <td colspan="6" class="col_all">
                            <p>
                                <span><spring:message code='commission.text.selectMonth' /></span>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" class="col_all al_center">
                            <table class="type2" style="width: 460px;">
                                <!-- table start -->
                                <caption>table</caption>
                                <colgroup>
                                    <col style="width: 340px" />
                                    <col style="width: 120px" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col" class="al_center">RC Rate</th>
                                        <th scope="col" class="al_center">SHI Index</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="al_center"><span>90% ~ 100% Excellent</span></td>
                                        <td class="al_center"><span>10%</span></td>
                                    </tr>
                                    <tr>
                                        <td class="al_center"><span>80% ~ 89% Very Good (target average)</span></td>
                                        <td class="al_center"><span>5%</span></td>
                                    </tr>
                                    <tr>
                                        <td class="al_center"><span>70% ~ 79% Good (above average)</span></td>
                                        <td class="al_center"><span>0%</span></td>
                                    </tr>
                                    <tr>
                                        <td class="al_center"><span>60% ~ 69% Poor (below average)</span></td>
                                        <td class="al_center"><span>-10%</span></td>
                                    </tr>
                                    <tr>
                                        <td class="al_center"><span>50% ~ 59% (serious)</span></td>
                                        <td class="al_center"><span>-20%</span></td>
                                    </tr>
                                    <tr>
                                        <td class="al_center"><span>0% ~ 49% (Worst)</span></td>
                                        <td class="al_center"><span>-30%</span></td>
                                    </tr>
                                </tbody>
                            </table>
                            <!-- table end -->
                        </td>
                    </tr>
                </tbody>
            </table>
        <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->
    <section class="search_result">
        <!-- search_result start -->
        <ul class="right_btns">
            <li>
                <p class="btn_grid"><a href="#" id="generate"><spring:message code='commission.button.generate' /></a></p>
                <!-- <p class="btn_grid"><a href="#" id="excelDown">GENERATE</a></p> -->
            </li>
        </ul>
        <article class="grid_wrap">
        <!-- grid_wrap start -->
            <div id="grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
            <div id="excel_list_grid_wrap" style="display: none;"></div>
        </article>
        <!-- grid_wrap end -->
    </section>
<!-- search_result end -->
</section>
<!-- content end -->
<hr />
</body>
</html>
