<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript" language="javascript">

    var gridID, listByMemberGridID;


    $(document).ready(function(){
        $("#table1").hide();

        if("${SESSION_INFO.userTypeId}" == "1" ||"${SESSION_INFO.userTypeId}" == "2" ){
            $("#table1").show();
        }

        if("${memLvl}" == "2") {

            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

            $("#grpCode").val("${grpCode}");
            $("#grpCode").attr("class", "w100p readonly");
            $("#grpCode").attr("readonly", "readonly");

        } else if("${memLvl}" == "3") {

            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

            $("#grpCode").val("${grpCode}");
            $("#grpCode").attr("class", "w100p readonly");
            $("#grpCode").attr("readonly", "readonly");

            $("#deptCode").val("${deptCode}");
            $("#deptCode").attr("class", "w100p readonly");
            $("#deptCode").attr("readonly", "readonly");

        } else if("${memLvl}" == "4") {

            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

            $("#grpCode").val("${grpCode}");
            $("#grpCode").attr("class", "w100p readonly");
            $("#grpCode").attr("readonly", "readonly");

            $("#deptCode").val("${deptCode}");
            $("#deptCode").attr("class", "w100p readonly");
            $("#deptCode").attr("readonly", "readonly");

            $("#memCode").val("${memCode}");
            $("#memCode").attr("class", "w100p readonly");
            $("#memCode").attr("readonly", "readonly");

        }

        gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "", gridPos);
        listByMemberGridID = GridCommon.createAUIGrid("#listByMember_grid_wrap", memberListingColumnLayout, "", gridPos);
        AUIGrid.resize(listByMemberGridID,945, $(".grid_wrap").innerHeight());

        AUIGrid.bind(gridID, "cellClick", function(event) {
            selectedGridValue = event.rowIndex;
        });
    });

    function fn_selectListAjax() {

        if($("#orgCode").val() == "" || $("#orgCode").val() == null) {
            Common.alert("Please enter orgnization code...");
            return;
        }

        Common.ajax("GET", "/services/bs/selectBsResultAnalysisList", $("#searchForm").serialize(), function(result) {

             console.log( result);

            AUIGrid.setGridData(gridID, result);
        });
    }

    var columnLayout = [
                                 { dataField : "orgCode", headerText : "Org Code", width : 80 },
                                 { dataField : "grpCode", headerText : "Grp Code", width : 80 },
                                 { dataField : "deptCode", headerText : "Dept Code", width : 80 },
                                 { dataField : "memCode", headerText : "Cody Code", width : 80 },
                                 { dataField : "totBs", headerText : "Unit", width : 80 },
                                 { dataField : "act", headerText : "Active", width : 80 },
                                 { dataField : "cmplt", headerText : "Complete", width : 80 },
                                 { dataField : "cmpltOwn", headerText : "Complete (Own)", width : 130 },
                                 { dataField : "cmpltOtr", headerText : "Complete (Other)", width : 140 },
                                 { dataField : "fail", headerText : "Fail", width : 80 },
                                 { dataField : "cancl", headerText : "Cancel", width : 80 },
                                 { dataField : "bsSuccesRateWeek1", headerText : "WEEK 1 (>30%)", dataType : "numeric", formatString : "#,##0.00", width : 120 },
                                 { dataField : "bsSuccesBalncWeek1", headerText : "Balance (By Unit)", width : 130 },
                                 { dataField : "bsSuccesRateWeek2", headerText : "WEEK 2 (>60%)", dataType : "numeric", formatString : "#,##0.00", width : 120 },
                                 { dataField : "bsSuccesBalncWeek2", headerText : "Balance (By Unit)", width : 130 },
                                 { dataField : "bsSuccesRateWeek3", headerText : "WEEK 3 (>90%)", dataType : "numeric", formatString : "#,##0.00", width : 120 },
                                 { dataField : "bsSuccesBalncWeek3", headerText : "Balance (By Unit)", width : 130 },
                                 { dataField : "bsSuccesRateWeek4", headerText : "WEEK 4 (100%)", dataType : "numeric", formatString : "#,##0.00", width : 120 },
                                 { dataField : "bsSuccesBalncWeek4", headerText : "Balance (By Unit)", width : 130 }
                                ];

    var memberListingColumnLayout = [
                                                    { dataField : "bsno", headerText : "BS No", width : 80 },
                                                    { dataField : "bsmonth", headerText : "BS Month", width : 80 },
                                                    { dataField : "bsyear", headerText : "BS Year", width : 80 },
                                                    { dataField : "bsstatusid", headerText : "BS Status", width : 80 },
                                                    { dataField : "bsrno", headerText : "Result No", width : 80 },
                                                    { dataField : "orderno", headerText : "Order No", width : 80 },
                                                    { dataField : "orderapptype", headerText : "App Type", width : 80 },
                                                    { dataField : "bscustname", headerText : "Customer", width : 130 },
                                                    { dataField : "memcode", headerText : "Assign Member", width : 140 },
                                                    { dataField : "actionmemcode", headerText : "Incharge Member", width : 80 },
                                                   ];

    var gridPos = {
                         usePaging : true,
                         pageRowCount : 20,
                         editable : false,
                         //fixedColumnCount : 1,
                         showStateColumn : true,
                         displayTreeOpen : false,
                         headerHeight : 30,
                         useGroupingPanel : false,
                         skipReadonlyColumns : true,
                         wrapSelectionMove : true,
                         showRowNumColumn : true
                        };


      function fn_doViewLegder(){

          var selectedItems = AUIGrid.getSelectedItems(gridID);
          console.log(selectedItems);

          if(selectedItems.length <= 0) {
              Common.alert("<spring:message code="sal.alert.noMembershipSelect" /> ");
              return;
          }
          Common.popupDiv("/sales/membership/selMembershipViewLeader.do?MBRSH_ID="+selectedItems[0].item.mbrshId, null, null , true, '_ViewLegder');
      }

    function fn_clear(){
    	if("${memLvl}" == "4") {
    		$('#clear').hide();
    	} else if("${memLvl}" == "3") {
            $("#memCode").val("");
    	} else if("${memLvl}" == "2") {
            $("#deptCode").val("");
            $("#memCode").val("");
    	} else if("${memLvl}" == "1") {
    		$("#grpCode").val("");
            $("#deptCode").val("");
            $("#memCode").val("");
    	}
    }

    function fn_openDivPop(val) {
        var selectedItem = AUIGrid.getSelectedIndex(gridID);

        var memCode = AUIGrid.getCellValue(gridID, selectedGridValue, "memCode");

        if(selectedItem[0] > -1) {
            Common.ajax("GET", "/services/bs/selResultAnalysisByMember.do", {"memCode" : memCode}, function(result) {
            	console.log( result);

                AUIGrid.setGridData(listByMemberGridID, result)
            });

            $("#view_wrap").show();

            if(val == "VIEW"){
                var date = new Date();
                var dateTime = date.getDate().toString() + "-" + date.getMonth().toString() + "-" + date.getFullYear().toString() + " " + date.toLocaleTimeString();

                $('#pop_header h1').text('BS Listing - By Member');
                $('#pop_header h3').text('Before Service (BS) Listing by ' + memCode + ' as at ' + dateTime);
                $('#center_btns1').hide();
                $('#center_btns2').hide();
                $('#center_btns3').hide();
                $('#center_btns4').hide();

            }
        } else {
            Common.alert('No record selected.');
        }
    }


</script>


<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>BS Management - Result Analysis</h2>
        <ul class="right_btns">
            <!-- <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                <li><p class="btn_blue"><a href="#" onClick="fn_print()"><spring:message code='service.btn.Generate'/></a></p></li>
            </c:if> -->
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <li><p class="btn_blue"><a id="search" href="#" onClick="javascript:fn_selectListAjax();"><span class="search"></span><spring:message code="sys.btn.search"/></a></p></li>
            </c:if>
            <li><p class="btn_blue"><a id="clear" href="#" onclick="javascript:fn_clear()"><span class="clear"></span><spring:message code="sys.btn.clear" /></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form action="#"  name="searchForm" id="searchForm"  method="post">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:140px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Organization Code</th>
                        <td >
                            <input type="text" title=""   id="orgCode" name="orgCode" placeholder="Organization" class="w100p" value="${orgCode}" />
                        </td>
                        <th scope="row">Group Code</th>
                        <td >
                            <input type="text" title=""   id="grpCode" name="grpCode" placeholder="Group Code" class="w100p" />
                        </td>
                        <th scope="row">Department Code</th>
                        <td >
                            <input type="text" title=""   id="deptCode" name="deptCode" placeholder="Department Code" class="w100p" />
                        </td>
                        <th scope="row">Member Code</th>
                        <td >
                            <input type="text" title=""   id="memCode" name="memCode" placeholder="Member Code" class="w100p" />
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->

            <!-- link_btns_wrap start -->
            <aside class="link_btns_wrap">
                <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                    <ul class="btns">
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('VIEW');">BS Listing - By Member</a></p></li>
                    </ul>
                    <ul class="btns">
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
            </aside>
            <!-- link_btns_wrap end -->

        </form>
    </section>
    <!-- search_table end -->

    <!-- search_result start -->
    <section class="search_result">
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="list_grid_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
    </article>
    <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->

</section>
<!-- content end -->

<!-- popup_wrap start -->
<div class="popup_wrap" id="view_wrap" style="display: none;">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header">
        <h1></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2">
                    <a href="#" onclick="hideViewPopup('#view_wrap')">CLOSE</a>
                </p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <section class="pop_body">
        <!-- tap_wrap start -->
        <!-- <section class="search_table"> search_table start -->
            <!-- #########BS Listing######### -->
            <article class="tap_area">
                <!-- tap_area start -->
                <!-- table start -->
                    <!-- grid_wrap start -->
                    <aside class="title_line"><!-- title_line start -->
                    <header class="pop_header" id="pop_header">
                    <h3></h3>
                        <!-- <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                            <ul class="right_btns">
                                <li><p class="btn_blue2"><a href="javascript:fn_print('')">Print</a></p></li>
                            </ul>
                        </c:if> -->
                     </header>
                    </aside><!-- title_line end -->

                    <table class="type1">
                        <caption>table</caption>
                        <tbody>
                            <tr>
                                <td colspan='5'>
                                    <div id="listByMember_grid_wrap" style="width: 100%; height: 480px; margin: 0 auto;"></div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- table end -->
                </article>
                <!-- grid_wrap end -->
            <!-- tap_area end -->
            <!-- </section> search_table end -->
        <!-- tap_wrap end-->
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->