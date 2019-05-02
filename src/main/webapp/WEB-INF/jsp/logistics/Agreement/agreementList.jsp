<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID;

var cnfmDt, joinDt;

$(document).ready(function() {

    console.log("agreement");

    $("#agreementVersion").attr("disabled", true);
    $("#memLevelCom").attr("disabled", true);
    //$("#selectBranch").attr("disabled", true);

    doGetCombo('/logistics/agreement/getMemStatus', null, '' ,'memStusCmb' , 'S');

    console.log($("#userRole").val());

    if($("#userRole").val() == 97 || $("#userRole").val() == 98 || $("#userRole").val() == 99 || $("#userRole").val() == 100 || // SO Branch
            $("#userRole").val() == 103 || $("#userRole").val() == 104 || $("#userRole").val() == 105 || // DST Support
            $("#userRole").val() == 128 || $("#userRole").val() == 129 || $("#userRole").val() == 130 || // Administrator
            $("#userRole").val() == 166 || $("#userRole").val() == 167 || $("#userRole").val() == 261 || // DST Planning
            $("#userRole").val() == 243 || // Compliance
            $("#userRole").val() == 177 || $("#userRole").val() == 179 || $("#userRole").val() == 180 || // Cody Support
            $("#userRole").val() == 200 || $("#userRole").val() == 252 || $("#userRole").val() == 253 || // Cody Planning
            $("#userRole").val() == 250 || $("#userRole").val() == 256 ) { // Cody Branch

        //doGetComboSepa("/common/selectBranchCodeList.do",2 , '-',''   , 'branch' , 'S', '');

        if($("#userRole").val() == 97 || $("#userRole").val() == 98 || $("#userRole").val() == 99 || $("#userRole").val() == 100 || // SO Branch
                $("#userRole").val() == 103 || $("#userRole").val() == 104 || $("#userRole").val() == 105 || // DST Support
                $("#userRole").val() == 166 || $("#userRole").val() == 167 || $("#userRole").val() == 261) { // DST Planning

            $('#memTypeCom option[value="1"] ').attr("selected", true);
            $('#memTypeCom').attr("disabled", true);

            doGetCombo('/logistics/agreement/getAgreementVersion', '1', '' ,'agreementVersion' , 'S');
            $("#memLevelCom").attr("disabled", false);
            $("#agreementVersion").attr("disabled", false);
            $("#selectBranch").attr("disabled", true);

            $("#memLevelCom option[value='4']").attr("selected", true); // Temporary default to HP only

            $('#selectBranch option[value="0"] ').attr("selected", true);

            $("#selectBranchCol").attr("hidden", true);
            $("#selectBranchLbl").attr("hidden", true);
            $("#selectBranch").attr("hidden", true);

        } else if($("#userRole").val() == 177 || $("#userRole").val() == 179 || $("#userRole").val() == 180 || // Cody Support
                $("#userRole").val() == 200 || $("#userRole").val() == 252 || $("#userRole").val() == 253 || // Cody Planning
                $("#userRole").val() == 250 || $("#userRole").val() == 256 ){

            var brnch = "${branch}";
            $('#selectBranch option[value="' + brnch +'"] ').attr("selected", true);

            $('#memTypeCom option[value="2"] ').attr("selected", true);
            $('#memTypeCom').attr("disabled", true);

            doGetCombo('/logistics/agreement/getAgreementVersion', '2', '' ,'agreementVersion' , 'S');
            $("#memLevelCom").attr("disabled", false);
            $("#agreementVersion").attr("disabled", false);

            $("#memLevelCom option[value='4']").attr("selected", true); // Temporary default to Cody only

            if($("#userRole").val() == 177 || $("#userRole").val() == 256) {
                $("#selectBranch").attr("disabled", true);
            }
        }

        createAUIGrid();
        AUIGrid.setSelectionMode(myGridID, "singleRow");

        AUIGrid.bind(myGridID, "cellClick", function(event) {
            memberid = AUIGrid.getCellValue(myGridID, event.rowIndex, "memcode");
            joinDt = AUIGrid.getCellValue(myGridID, event.rowIndex, "joinDt");
            cnfmDt = AUIGrid.getCellValue(myGridID, event.rowIndex, "cnfmDt");
    	});

    } else {

        $("#versionLbl").attr("hidden", true);
        $("#versionCol").attr("hidden", true);
        $("#agreementVersion").attr("hidden", true);

        var memType = "${memType}";

        //doGetCombo('/logistics/agreement/getMemLevel', memType, '' ,'memLevelCom' , 'S');
        doGetCombo('/logistics/agreement/getAgreementVersion', memType, '' ,'agreementVersion' , 'S');

        if(memType == 1 || memType == 2) {
            $("#memTypeCom > option[value='" + memType +"']").attr("selected", true);
        }

        $("#code").val("${memCode}");

        Common.ajax("GET", "/logistics/agreement/getMemberInfo", {memID : "${memCode}", memType : memType}, function(result) {
            console.log(result);

            $("#name").val(result.name);
            $("#icNum").val(result.nric);
            $("#deptCode").val(result.deptCode);
            $("#grpCode").val(result.grpCode);
            $("#memStusCmb option[value='" + result.stus + "']").attr("selected", true);
            $("#memLevelCom option[value='" + result.memLvl + "']").attr("selected", true);
            $("#joinDt").val(result.joinDt);
            $("#cnfmDt").val(result.cnfmDt);

            if(memType == 1) {
                $("#agreementVersion option[value='" + result.signDt +"']").attr("selected", true);

                $("#selectBranchCol").attr("hidden", true);
                $("#selectBranchLbl").attr("hidden", true);
                $("#selectBranch").attr("hidden", true);

                //userAgreement
                $("#userAgreement").val(result.signDt);

                $("#promoDt").val(result.promoDt);

                if(result.memLvl == 4) {
                    $("#startDt").attr("disabled", true);
                }
            }

            if(memType == 2) {
                $("#agreementVersion > option[value='2017']").attr("selected", true);
                $("#agreementVersion").attr("disabled", false);
            }
        });

        $("#memTypeCom").attr("disabled", true);
        $("#memStusCmb").attr("disabled", true);
        $("#memLevelCom").attr("disabled", true);
        $("#name").attr("disabled", true);
        $("#icNum").attr("disabled", true);
        $("#code").attr("disabled", true);
        $("#deptCode").attr("disabled", true);
        $("#grpCode").attr("disabled", true);
        $("#orgCode").attr("disabled", true);
        $("#grid_wrap_memList").attr("hidden", true);
    }

    /*$("#startDt").blur(function() {
        console.log($("#startDt").val());
    });*/
    $("#startDt").on("change", function() {
        console.log($("#startDt").val());

        var day = $("#startDt").val().substring(0, 2);
        var mth = $("#startDt").val().substring(3, 5);
        var year = $("#startDt").val().substring(6);

        var expDay = "";
        var expMth = "";

        if($("#memTypeCom").val() == "01") {
            if(mth <= "06") {
                expDay = "30";
                expMth = "06";
            } else {
                expDay = "31";
                expMth = "12";
            }
        } else {
            expDay = "31";
            expMth = "03";

            var expYYYY = year;

            if(mth == "01" || mth == "02" || mth == "03") {
                year = expYYYY;
            } else {
                year = Number(year) + 1;
            }

        }

        $("#endDt").val(expDay + "/" + expMth + "/" + year);
    });
});

function fn_onChgMemType() {

    var memType = $("#memTypeCom").val();

    if(memType != '') {
        // Member Level
        doGetCombo('/logistics/agreement/getMemLevel', memType, '' ,'memLevelCom' , 'S');
        $("#memLevelCom").attr("disabled", false);
        $('#memLevelCom option[value="4"] ').attr("selected", true);

        // Agreement Version
        doGetCombo('/logistics/agreement/getAgreementVersion', memType, '' ,'agreementVersion' , 'S');
        $("#agreementVersion").attr("disabled", false);

        if(memType == "2") {
            $("#selectBranch").attr("disabled", false);
        }
    } else {
        $("#memLevelCom").empty();
        $("#agreementVersion").empty();

        $("#memLevelCom").append("<option value=''>Choose One</option>");
        $("#agreementVersion").append("<option value=''>Choose One</option>");

        $("#memLevelCom").attr("disabled", true);
        $("#agreementVersion").attr("disabled", true);
    }

}

function fn_searchMember() {

    if($("#memTypeCom").val() == "") {
        Common.alert("Please select one member type.");
        return false;
    }

    var obj = {
        code : $("#code").val(),
        name : $("#name").val(),
        icNum : $("#icNum").val(),
        memTypeCom : $("#memTypeCom").val(),
        memLevelCom : $("#memLevelCom").val(),
        memStusCmb : $("#memStusCmb").val(),
        deptCode : $("#deptCode").val(),
        grpCode : $("#grpCode").val(),
        orgCode : $("#orgCode").val(),
        selectBranch : $("#selectBranch").val()
    };

    Common.ajax("GET", "/logistics/agreement/memberList", obj, function(result) {

        console.log("search");
        console.log(result);

        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_downloadAgreement() {

    var version = $("#agreementVersion").val();
    console.log(version);

    var option = {
        isProcedure : true
    };

    var code;

    if($("#userRole").val() == 97 || $("#userRole").val() == 98 || $("#userRole").val() == 99 || $("#userRole").val() == 100 || // SO Branch
            $("#userRole").val() == 103 || $("#userRole").val() == 104 || $("#userRole").val() == 105 || // DST Support
            $("#userRole").val() == 128 || $("#userRole").val() == 129 || $("#userRole").val() == 130 || // Administrator
            $("#userRole").val() == 166 || $("#userRole").val() == 167 || $("#userRole").val() == 261) {

        code = memberid;
        $("#v_memCode").val(memberid);

    } else {
        code = $("#code").val();
        if(code != "") {
            $("#v_memCode").val($("#code").val());
        } else {
        	code = memberid;
            $("#v_memCode").val(memberid);
        }
    }

    if($("#memTypeCom").val() == "1") {
        // HP Download
        console.log("memLvl :: " + $("#memLevelCom").val());
        var memLvl = $("#memLevelCom").val();

        if(memLvl < "4" && memLvl != "") {
            if(FormUtil.checkReqValue($("#startDt")) && FormUtil.checkReqValue($("#startDt"))) {
                Common.alert("Please key in contract start date.");
                return false;
            }

            if($("startDt").val() != "") {
                var day = $("#startDt").val().substring(0, 2);
                var mth = $("#startDt").val().substring(3, 5);
                var year = $("#startDt").val().substring(6);

                var startDt = new Date(year, mth - 1, day);

                // 2018-12-11 - LaiKW - HM, SM, GM e-Agreement commence start date @ 2018-07-01
                var d = new Date(2018, 06, 01);
                console.log(d);

                var startDt = new Date(year, mth - 1, day);

                if(startDt < d) {
                    Common.alert("For Manager level and above agreement, please refer to Sales Planning for scanned copy.");
                    return false;
                }
            }
        }

        Common.ajax("GET", "/logistics/agreement/getMemberInfo", {memID : code, memType : $("#memTypeCom").val()}, function(result) {
            console.log(result);

            var signDt = result.signDt;
            if(signDt == "" || signDt == null) {
            	signDt = "201604";
            }

            if(result.memLvl == "4") {
                $("#reportFileName").val("/logistics/HPAgreement_" + signDt + ".rpt");
                $("#reportDownFileName").val("HPAgreement_" + code);
            } else {
            	$("#v_contractStartDt").val($("#startDt").val());
            	$("#v_contractEndDt").val($("#endDt").val());

                $("#reportFileName").val("/logistics/HMAgreement_20180704.rpt");
                $("#reportDownFileName").val("Manager_Agreement_" + code);
            }

            Common.report("agreementReport", option);

            console.log($("#reportFileName").val());
        });

    } else if($("#memTypeCom").val() == "2") {
        // CD Download

        //Common.ajax("GET", "/logistics/agreement/cdEagmt1", {memID : code, memType : $("#memTypeCom").val()}, function(result) {
            //console.log(result);

            //var signDt = result.signdt.substring(0, 5);

            //console.log(signDt);
            //if($("#agreementVersion").val() < signdt.substring(0, 3))
        //});

        var gridObj = AUIGrid.getSelectedItems(myGridID);
        $("#joinDt").val(gridObj[0].item.joinDt);
        $("#cnfmDt").val(gridObj[0].item.cdCnfmDt);

        //$("#joinDt").val(AUIGrid.getCellValue(myGridID, event.rowIndex, "joinDt"));
        //$("#cnfmDt").val(AUIGrid.getCellValue(myGridID, event.rowIndex, "cnfmDt"));

        if(FormUtil.checkReqValue($("#startDt"))) {
            Common.alert("Please key in contract start date.");
            return false;
        } else {
            if($("#startDt").val() < "01/04/2018") {
                Common.alert("Please contact admin for older versions agreement.");
                return false;
            }
        }

        var dd, mm, yyyy;

        var today = new Date();

        var cYr = today.getFullYear();
        var nYr = today.getFullYear() + 1;
        var pYr = today.getFullYear() - 1;

        var currPeriod = new Date(cYr +"-04-01");
        var nextPeriod = new Date(nYr + "-04-01");
        var prevPeriod = new Date(pYr + "-04-01");

        var ePeriod = new Date('2018-04-01');

        var dt = $("#startDt").val().split("/");
        var selStartDt = new Date(dt[2] + "-" + dt[1] + "-" + dt[0]);

        dt = $("#cnfmDt").val().split("/");
        var cnfmDt = new Date(dt[2] + "-" + dt[1] + "-" + dt[0]);

        dt = $("#joinDt").val().split("/");
        var joinDt = new Date(dt[2] + "-" + dt[1] + "-" + dt[0]);

        if(cnfmDt == "1900-01-01") {
            Common.alert("Agreement not accepted.");
            return false;
        } else {
            if(selStartDt <= joinDt && selStartDt < nextPeriod) {
                dd = joinDt.getDate();
                mm = joinDt.getMonth() + 1;
                yyyy = joinDt.getFullYear();
                joinDt = yyyy + "-" + mm + "-" + dd;
                $("#v_contractStartDt").val(joinDt);

            } else if(selStartDt >= currPeriod && selStartDt < nextPeriod) {
                dd = currPeriod.getDate();
                mm = currPeriod.getMonth() + 1;
                yyyy = currPeriod.getFullYear();
                currPeriod = yyyy + "-" + mm + "-" + dd;
                $("#v_contractStartDt").val(currPeriod);

            } else if(selStartDt < currPeriod && selStartDt >= joinDt && selStartDt >= ePeriod) {
                $("#v_contractStartDt").val("2018-04-01");

            } else if(joinDt > prevPeriod && joinDt < currPeriod) {
            	dd = joinDt.getDate();
                mm = joinDt.getMonth() + 1;
                yyyy = joinDt.getFullYear();
                joinDt = yyyy + "-" + mm + "-" + dd;
                $("#v_contractStartDt").val(joinDt);

            } else if(selStartDt > nextPeriod && cnfmDt < nextPeriod) {
                Common.alert("Only 2018/04/01 to today is permitted.");
                return false;

            } else if(joinDt < ePeriod) {
                Common.alert("Only 2018/04/01 to today is permitted.");
                return false;
            }
        }

        console.log("v_contractStartDt :: " + $("#v_contractStartDt").val());

        $("#reportFileName").val("/logistics/CodyAgreement_2017.rpt");
        $("#reportDownFileName").val("CodyAgreement_" + code);

        console.log("reportFileName :: " + $("#reportFileName").val());

        Common.report("agreementReport", option);
    }
}

function createAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ { dataField : "memtype",
        headerText : "Member Type",
        editable : false,
        width : 130,
        visible : false
    }, {
        dataField : "memcode",
        headerText : "Member Code",
        editable : false,
        width : 130
    }, {
        dataField : "name",
        headerText : "Member Name",
        editable : false,
        width : 300
    }, {
        dataField : "nric",
        headerText : "Member NRIC",
        editable : false,
        style : "my-column",
        width : 130
    }, {
        dataField : "deptcode",
        headerText : "Department Code",
        editable : false,
        width : 150
    }, {
        dataField : "grpcode",
        headerText : "Group Code",
        editable : false,
        width : 150,
    }, {
        dataField : "orgcode",
        headerText : "Organization Code",
        editable : false,
        width : 150
    }, {
        dataField : "userrole",
        headerText : "User Role",
        editable : false,
        width : 130
    }, {
        dataField : "status",
        headerText : "Status",
        editable : false,
        width : 130
    }, {
        dataField : "promoDt",
        editable : false,
        visible : false
    }, {
        dataField : "joinDt",
        visible : false
    }, {
        dataField : "cnfmDt",
        visible : false
    }, {
        dataField : "cdCnfmDt",
        visible : false
    }
    ]; //visible : false

    var gridPros = {

             usePaging                   : true,
             pageRowCount             : 20,
             editable                      : false,
             showStateColumn         : false,
             displayTreeOpen           : false,
             selectionMode              : "singleRow",
             headerHeight               : 30,
             useGroupingPanel         : false,
             skipReadonlyColumns    : true,
             wrapSelectionMove      : true,
             showRowNumColumn     : true
    };

    myGridID = AUIGrid.create("#grid_wrap_memList", columnLayout, gridPros);
}

</script>

<!-- --------------------------------------DESIGN------------------------------------------------ -->

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>e-Agreement</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>e-Agreement</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="javascript:fn_searchMember();"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="javascript:fn_downloadAgreement();">Download</a></p></li>

    <!-- <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="btn_blue"><a href="javascript:fn_searchMember();"><span class="search"></span>Search</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
        <li><p class="btn_blue"><a href="javascript:fn_downloadAgreement();">Download</a></p></li>
    </c:if> -->
</ul>
</aside><!-- title_line end -->

<input type="hidden" id="userRole" name="userRole" value="${userRole} " />
<input type="hidden" id="userAgreement" name="userAgreement" />

<form id="agreementReport" name="agreementReport">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

    <input type="hidden" id="v_memCode" name="v_memCode" value="" />
    <input type="hidden" id="v_contractStartDt" name="v_contractStartDt" value="" />
    <input type="hidden" id="v_contractEndDt" name="v_contractEndDt" value="" />
</form>

<section class="search_table"><!-- search_table start -->
<form action="#" id="searchForm" method="post">

<input type="hidden" id="promoDt" name="promoDt" value="" />
<input type="hidden" id="joinDt" name="joinDt" />
<input type="hidden" id="cnfmDt" name="cnfmDt" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Code</th>
    <td>
    <input type="text" title="Code" placeholder="" class="w100p" id="code" name="code" />
    </td>
    <th scope="row">Name</th>
    <td>
    <input type="text" title="Name" placeholder="" class="w100p" id="name" name="name" />
    </td>
    <th scope="row">IC Number</th>
    <td>
    <input type="text" title="IC Number" placeholder="" class="w100p" id="icNum" name="icNum" />
    </td>
</tr>
<tr>
    <th scope="row">Member Type<span class="must">*</span></th>
    <td>
        <select class="w100p" id="memTypeCom" name="memTypeCom" onChange="javascript : fn_onChgMemType()">
            <option value="" selected>Select Account</option>
            <option value="1">Health Planner</option>
            <option value="2">Cody</option>
        </select>
    </td>
    <th scope="row">Member Level</th>
    <td>
        <select class="w100p"  id="memLevelCom" name="memLevelCom" >
            <option value="">Choose One</option>
                <c:forEach var="list" items="${memLevel}" varStatus="status">
                    <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
        </select>
    </td>
    <th scope="row">Status</th>
    <td>
        <select class="w100p" id="memStusCmb" name="memStusCmb"></select>
    </td>
</tr>
<tr>
    <th scope="row">Department Code</th>
    <td>
        <input type="text" class="w100p" id="deptCode" name="deptCode" value="${deptCode}" />
    </td>
    <th scope="row">Group Code</th>
    <td>
        <input type="text" class="w100p" id="grpCode" name="grpCode" value="${grpCode}" />
    </td>
    <th scope="row">Organization Code</th>
    <td>
        <input type="text" class="w100p" id="orgCode" name="orgCode" value="${orgCode}" />
    </td>
</tr>
<tr>
    <th scope="row" id="selectBranchLbl">Branch</th>
    <td id="selectBranchCol">
     <!-- <span><c:out value="${memberView.c4} - ${memberView.c5} " /></span>-->
     <select class="w100p"  id="selectBranch" name="selectBranch" >
        <option value="0">Choose One</option>
        <c:forEach var="list" items="${branchList}" varStatus="status">
           <option value="${list.brnchId}">${list.branchCode} - ${list.branchName}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Contract Period</th>
    <td>
        <div class="date_set w100p"><!-- date_set start -->
            <p><input type="text" title="Contract Start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDt" name="startDt"/></p>
            <span><spring:message code="webInvoice.to" /></span>
            <p><input type="text" title="Contract End Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt" disabled/></p>
        </div><!-- date_set end -->
    </td>
    <th scope="row" id="versionLbl">Version</th>
    <td  id="versionCol">
        <!-- Version option value to be added into SQL  -->
        <select class="w100p" id="agreementVersion" name="agreementVersion"></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrap_memList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

<input type="hidden" id="userRole" name="userRole" value="${userRole} " />

<form id="agreementReport" name="agreementReport" style="display:none">
    <input id="reportFileName" name="reportFileName" value="/organization/HPAgreement.rpt" />
    <input id="viewType" name="viewType" value="PDF" />
    <input id="reportDownFileName" name="reportDownFileName" />

    <input id="v_memCode" name="v_memCode" value="" />
</form>

<form id="applicantValidateForm" method="post">
    <div style="display:none">
        <input type="text" name="aplcntCode"  id="aplcntCode"/>
        <input type="text" name="aplcntNRIC"  id="aplcntNRIC"/>
    </div>
</form>

</section><!-- content end -->
