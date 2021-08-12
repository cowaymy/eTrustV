<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript" language="javascript">

    var myGridID;
    var gridValue;

    var userName, userRole, userType;

    $(document).ready(function() {
    	
    	doGetCombo('/organization/selectHpMeetPoint.do', '', '', 'meetingPoint', 'S', '');

        userName = "${userName}";
        userRole = ${userRole};
        userType = ${userType};

        if(userRole == 128 || userRole == 129 || userRole == 130 || // Administratior
           userRole == 166 || userRole == 167 || userRole == 261 || // Sales Planning
           userRole == 335 || userRole == 336 || userRole == 337 || // Org Interaction
           userRole == 268 || userRole == 320 || // Organisation Development
           userRole == 95 || userRole == 96 || // Planning
           userRole == 106 || userRole == 109 || userRole == 111 || userRole == 112 || userRole == 113 || userRole == 114 || userRole == 115) { // Health Planner

            if(userRole == 106 || userRole == 109 || userRole == 111 || userRole == 112 || userRole == 113 || userRole == 114 || userRole == 115) {
                Common.ajax("GET", "/logistics/agreement/getMemberInfo", {memID : userName, memType : userType}, function(result) {
                    console.log(result);

                    if(userRole == 114 || userRole == 115) { // HP or HM
                        $("#orgCode").val(result.orgCode);
                        $("#grpCode").val(result.grpCode);
                        $("#deptCode").val(result.deptCode);

                        $("#orgCode").attr("disabled", true);
                        $("#grpCode").attr("disabled", true);
                        $("#deptCode").attr("disabled", true);

                        if(userRole == 115) {
                            $("#hpCode").val(userName);
                            $("#hpCode").attr("disabled", true);

                            /*Common.ajax("GET", "/organization/checkHpType.do", {memCode : userName}, function(result1) {
                                console.log(result1);

                                $("#hpType").val(result1.hpType);
                                $("#hpType").attr("disabled", true);
                            })*/;
                        }
                    } else if(userRole == 113) { // SM
                        $("#orgCode").val(result.orgCode);
                        $("#grpCode").val(result.grpCode);

                        $("#orgCode").attr("disabled", true);
                        $("#grpCode").attr("disabled", true);
                    } else if(userRole == 112) {
                        $("#orgCode").val(result.orgCode);

                        $("#orgCode").attr("disabled", true);
                    }
                });
            }
        } else {
            $("#searchBtn").hide();
            $("#genExcelBtn").hide();
        }

        createAUIGrid();
        AUIGrid.setSelectionMode(myGridID, "singleRow");
    });

    function createAUIGrid(){
        // AUIGrid 칼럼 설정
        var columnLayout = [
            {
                dataField : "memCode",
                headerText : "Member<br/>Code",
                width : "8%"
            }, {
                dataField : "memName",
                headerText : "Member  Name",
                width : "20%"
            }, {
                dataField : "orgCode",
                headerText : "Org Code",
                width : "8%"
            }, {
                dataField : "grpCode",
                headerText : "Grp Code",
                width : "8%"
            }, {
                dataField : "deptCode",
                headerText : "Dept Code",
                width : "8%"
            }, {
                dataField : "meetPoint",
                headerText : "Reporting<br/>Branch",
                width : "8%"
            }, {
                dataField : "joinDt",
                headerText : "Join Date",
                width : "8%"
            }, {
                dataField : "prev3MthNet",
                headerText : "Prev 3 Mth",
                width : "8%"
            }, {
                dataField : "prev2MthNet",
                headerText : "Prev 2 Mth",
                width : "8%"
            }, {
                dataField : "prev1MthNet",
                headerText : "Prev 1 Mth",
                width : "8%"
            }, {
                dataField : "totNet",
                headerText : "Total<br/>Net Sales",
                width : "8%"
            }, {
                dataField : "curMthNet",
                headerText : "Current<br/>Net Sales",
                width : "8%"
            }
        ];

        var gridPros = {
            usePaging : true,
            pageRowCount : 20,
            editable : false,
            showStateColumn : false,
            displayTreeOpen : true,
            headerHeight : 45,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
            showRowNumColumn : true,
        };

        myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    }

    function resetUpdatedItems() {
        AUIGrid.resetUpdatedItems(myGridID, "a");
    }

    function fn_getNeoProAndHPListAjax() {
        var data = {
            hpCode : $("#hpCode").val(),
            hpType : $("#hpType").val(),
            orgCode : $("#orgCode").val(),
            grpCode : $("#grpCode").val(),
            deptCode : $("#deptCode").val(),
            prev1Mth : $("#prev1Mth").val(),
            prev2Mth : $("#prev2Mth").val(),
            prev3Mth : $("#prev3Mth").val(),
            meetPoint : $("#meetingPoint").val()
        };

        Common.ajax("GET", "/organization/selectNeoProAndHPList.do", data, function(result) {
            console.log(result);
            AUIGrid.setGridData(myGridID, result);
        });
    }

    function fn_genExcel() {
        var dd, mm, yy;

        var today = new Date();
        dd = today.getDate();
        mm = today.getMonth() + 1;
        yy = today.getFullYear();

        GridCommon.exportTo("grid_wrap", 'xlsx', "NEOPRO_HP_LISTING_" + yy + mm + dd + "_" + userName);
    }

</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Organization</li>
        <li>Organization Mgmt.</li>
        <li>NEOPRO & HP</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav">
            <a href="#" class="click_add_on">My menu</a>
        </p>
        <h2>Neo Pro & HP Listing</h2>
        <ul class="right_btns">
            <li>
                <p class="btn_blue">
                    <a href="#" onclick="javascript:fn_getNeoProAndHPListAjax();" id="searchBtn"><span class="search"></span>Search</a>
                    <a href="#" onclick="javascript:fn_genExcel();" id="genExcelBtn">Generate Excel</a>
                </p>
            </li>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
        <form name ="searchForm" id = "searchForm" action="#" method="post">

            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:155px" />
                    <col style="width:*" />
                    <col style="width:155px" />
                    <col style="width:*" />
                    <col style="width:155px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">HP Code</th>
                        <td>
                            <input type="text" title="" placeholder="" class="w100p" id="hpCode" name="hpCode" />
                        </td>
                       	<th scope="row">Reporting Branch</th>
                        <td>
                            <select class="w100p" id="meetingPoint" name="meetingPoint"></select>
                        </td>
                        <th scope="row"></th>
                        <td></td>
                    </tr>
                    <tr>
                        <th scope="row">Org Code</th>
                        <td>
                            <input type="text" title="" placeholder="" class="w100p" id="orgCode" name="orgCode" />
                        </td>
                        <th scope="row">Grp Code</th>
                        <td>
                            <input type="text" title="" placeholder="" class="w100p" id="grpCode" name="grpCode" />
                        </td>
                        <th scope="row">Dept Code</th>
                        <td>
                            <input type="text" title="" placeholder="" class="w100p" id="deptCode" name="deptCode" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Previous 3 Mth</th>
                        <td>
                            <select id ="prev3Mth" name = "prev3Mth" class="w100p">
                                <option value="" selected>Select Range</option>
                                <option value="0">0</option>
                                <option value="1">0-2</option>
                                <option value="2">3-9</option>
                                <option value="3">=>10</option>
                            </select>
                        </td>
                        <th scope="row">Previous 2 Mth</th>
                        <td>
                            <select  id ="prev2Mth" name = "prev2Mth"  class="w100p">
                                <option value="" selected>Select Range</option>
                                <option value="0">0</option>
                                <option value="1">0-2</option>
                                <option value="2">3-9</option>
                                <option value="3">=>10</option>
                            </select>
                        </td>
                        <th scope="row">Previous 1 Mth</th>
                        <td>
                            <select  id ="prev1Mth" name = "prev1Mth" class="w100p">
                                <option value="" selected>Select Range</option>
                                <option value="0">0</option>
                                <option value="1">0-2</option>
                                <option value="2">3-9</option>
                                <option value="3">=>10</option>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    </section><!-- search_table end -->

    <section class="search_result"><!-- search_result start -->
        <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="grid_wrap" style="width:100%; height:500px; margin:0 auto;"></div>
        </article><!-- grid_wrap end -->
    </section><!-- search_result end -->

</section><!-- content end -->