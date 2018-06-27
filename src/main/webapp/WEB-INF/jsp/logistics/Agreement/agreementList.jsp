<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID;

$(document).ready(function() {

    console.log("agreement");

    $("#agreementVersion").attr("disabled", true);
    $("#memLevelCom").attr("disabled", true);

    doGetCombo('/logistics/agreement/getMemStatus', null, '' ,'memStusCmb' , 'S');

    if($("#userRole").val() == 97 || $("#userRole").val() == 98 || $("#userRole").val() == 99 || $("#userRole").val() == 100 || // SO Branch
            $("#userRole").val() == 103 || $("#userRole").val() == 104 || $("#userRole").val() == 105 || // DST Support
            $("#userRole").val() == 128 || $("#userRole").val() == 129 || $("#userRole").val() == 130) { // Administrator

        createAUIGrid();
        AUIGrid.setSelectionMode(myGridID, "singleRow");

        AUIGrid.bind(myGridID, "cellClick", function(event) {
            memberid = AUIGrid.getCellValue(myGridID, event.rowIndex, "memcode");
    	});

    } else {

        var memType = "${memType}";

        doGetCombo('/logistics/agreement/getMemLevel', memType, '' ,'memLevelCom' , 'S');
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

            if(memType == 1) {
                $("#agreementVersion option[value='" + result.version +"']").attr("selected", true);
            }

            if(memType == 2) {
                $("#agreementVersion").attr("disabled", false);
            }
        })

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
});

function fn_onChgMemType() {

    var memType = $("#memTypeCom").val();

    // Member Level
    doGetCombo('/logistics/agreement/getMemLevel', memType, '' ,'memLevelCom' , 'S');
    $("#memLevelCom").attr("disabled", false);

    // Agreement Version
    doGetCombo('/logistics/agreement/getAgreementVersion', memType, '' ,'agreementVersion' , 'S');
    $("#agreementVersion").attr("disabled", false);
}

function fn_searchMember() {

    if($("#memTypeCom").val() == "") {
        Common.alert("Please select one member type.");
        return false;
    }

    Common.ajax("GET", "/logistics/agreement/memberList", $("#searchForm").serialize(), function(result) {

        console.log("search");
        console.log(result);

        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_downloadAgreement() {

    var version = $("#agreementVersion").val();
    console.log(version);

    $("#v_memCode").val($("#code").val());

    var option = {
        isProcedure : true
    };

    var code;

    if($("#userRole").val() == 97 || $("#userRole").val() == 98 || $("#userRole").val() == 99 || $("#userRole").val() == 100 || // SO Branch
            $("#userRole").val() == 103 || $("#userRole").val() == 104 || $("#userRole").val() == 105 || // DST Support
            $("#userRole").val() == 128 || $("#userRole").val() == 129 || $("#userRole").val() == 130) { // Administrator

        code = memberid;

        if($("#agreementVersion").val() == "") {
            Common.alert("Please select agreement version");
            return false;
        }
    } else {
        code = $("#code").val();
    }

    if($("#memTypeCom").val() == "1") {
        // HP Download

        Common.ajax("GET", "/logistics/agreement/getMemHPpayment", {memID : code}, function(result) {
            if(result.version != version) {
                Common.alert("Invalid agreement selected. Please select again.");
                return false;
            } else {
                $("#reportFileName").val("/logistics/HPAgreement_" + version + ".rpt");
                $("#reportDownFileName").val("HPAgreement_" + $("#code").val());

                Common.report("agreementReport", option);
            }
        });

    } else if($("#memTypeCom").val() == "2") {
        // CD Download
        $("#reportFileName").val("/logistics/CDAgreement_" + version + ".rpt");
        $("#reportDownFileName").val("CDAgreement_" + $("#code").val());

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
    } ]; //visible : false

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

<form id="agreementReport" name="agreementReport">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

    <input type="hidden" id="v_memCode" name="v_memCode" value="" />
</form>

<section class="search_table"><!-- search_table start -->
<form action="#" id="searchForm" method="post">

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
    <th scope="row">Status</th>
    <td>
        <select class="w100p" id="memStusCmb" name="memStusCmb">
    </td>
    <th scope="row">Member Level</th>
    <td>
        <select class="w100p" id="memLevelCom" name="memLevelCom">
            <option value="" selected></option>
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
    <th scope="row">Version</th>
    <td>
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
    <input id="reportDownFileName" name="reportDownFileName" value="${memCode}" />

    <input id="v_memCode" name="v_memCode" value="" />
</form>

<form id="applicantValidateForm" method="post">
    <div style="display:none">
        <input type="text" name="aplcntCode"  id="aplcntCode"/>
        <input type="text" name="aplcntNRIC"  id="aplcntNRIC"/>
    </div>
</form>

</section><!-- content end -->
