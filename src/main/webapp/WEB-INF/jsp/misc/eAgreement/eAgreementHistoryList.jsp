<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID;
var cnfmDt, joinDt, agmtStus, memberid;

$(document).ready(function() {
	 console.log('eAgreementHistoryList');
 	 $("#memLevelCom").attr("disabled", true);

     doGetCombo('/logistics/agreement/getMemStatus', null, '' ,'memStusCmb' , 'S');

     userRoleHandling();
});

function createAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [
	{
	    dataField : "aplctnId",
	    headerText : "ID",
	    visible : false
	},
    {
        dataField : "aplicntType",
        headerText : "Member Type",
        visible : false
    },
	{
	    dataField : "cnfm",
	    headerText : "cnfm",
	    visible : false
	},
	{
	    dataField : "memLvl",
	    headerText : "memLvl",
	    visible : false
	},
	{
        dataField : "rptCnfmDt",
        headerText : "rptCnfmDt",
	    visible : false
    },
	{
        dataField : "joinDt",
        headerText : "joinDt",
	    visible : false
    },
	{
        dataField : "rptFileName",
        headerText : "rptFileName",
	    visible : false
    },
	{
        dataField : "aplicntCode",
        headerText : "Member Code",
        width : 130
    }, {
        dataField : "aplicntFullName",
        headerText : "Member Name",
        width : 300
    }, {
        dataField : "aplicntNric",
        headerText : "Member NRIC",
        style : "my-column",
        width : 130
    }, {
        dataField : "deptCode",
        headerText : "Department Code",
        width : 150
    }, {
        dataField : "lastGrpCode",
        headerText : "Group Code",
        width : 150,
    }, {
        dataField : "lastOrgCode",
        headerText : "Organization Code",
        width : 150
    }, {
        dataField : "crtDt",
        headerText : "Request Create Date"
    }, {
        dataField : "cnfmStus",
        headerText : "Agreement Status",
        width : 130
    }, {
        dataField : "cnfmDt",
        headerText : "Agreement Date",
        width : 130
    }, {
        dataField : "stusName",
        headerText : "Member Status",
        width : 130
    }, {
        dataField : "joinDt",
        headerText : "Join Date"
    }
    ];

    var gridPros = {
             usePaging            : true,
             pageRowCount         : 20,
             editable             : false,
             showStateColumn      : false,
             displayTreeOpen      : false,
             selectionMode        : "singleRow",
             headerHeight         : 30,
             useGroupingPanel     : false,
             skipReadonlyColumns  : true,
             wrapSelectionMove    : true,
             showRowNumColumn     : true
    };

    myGridID = AUIGrid.create("#grid_wrap_memList", columnLayout, gridPros);
}

function userRoleHandling() {
	 if($("#userRole").val() == 97 || $("#userRole").val() == 98 || $("#userRole").val() == 99 || $("#userRole").val() == 100 || // SO Branch
	            $("#userRole").val() == 103 || $("#userRole").val() == 104 || $("#userRole").val() == 105 || // DST Support
	            $("#userRole").val() == 128 || $("#userRole").val() == 129 || $("#userRole").val() == 130 || // Administrator
	            $("#userRole").val() == 421 || $("#userRole").val() == 420 || $("#userRole").val() == 402 || // Administrator New (ITGC)
	            $("#userRole").val() == 403 || $("#userRole").val() == 405 || $("#userRole").val() == 406 || // Administrator New (ITGC)
	            $("#userRole").val() == 415 || $("#userRole").val() == 414 ||                                            // Administrator New (ITGC)
	            $("#userRole").val() == 166 || $("#userRole").val() == 167 || $("#userRole").val() == 261 || // DST Planning
	            $("#userRole").val() == 335 || $("#userRole").val() == 336 || $("#userRole").val() == 337 || // Sales Care
	            $("#userRole").val() == 243 || $("#userRole").val() == 264 ||// Compliance
	            $("#userRole").val() == 177 || $("#userRole").val() == 179 || $("#userRole").val() == 180 || // Cody Support
	            $("#userRole").val() == 200 || $("#userRole").val() == 252 || $("#userRole").val() == 253 || // Cody Planning
	            $("#userRole").val() == 250 || $("#userRole").val() == 256 || // Cody Branch
	            $("#userRole").val() == 342 || $("#userRole").val() == 343 || $("#userRole").val() == 344 // Home care
	    ) {

	        if($("#userRole").val() == 97 || $("#userRole").val() == 98 || $("#userRole").val() == 99 || $("#userRole").val() == 100 || // SO Branch
	                $("#userRole").val() == 103 || $("#userRole").val() == 104 || $("#userRole").val() == 105 || // DST Support
	                $("#userRole").val() == 166 || $("#userRole").val() == 167 || $("#userRole").val() == 261 || // DST Planning
	                $("#userRole").val() == 335 || $("#userRole").val() == 336 || $("#userRole").val() == 337 // Sales Care
	           ) {

	            $('#memTypeCom option[value="1"] ').attr("selected", true);
	            $('#memTypeCom').attr("disabled", true);

	            $("#memLevelCom").attr("disabled", false);
	            $("#memLevelCom option[value='4']").attr("selected", true); // Temporary default to HP only

	            $("#selectBranch").attr("disabled", true);
	            $('#selectBranch option[value="0"] ').attr("selected", true);

	            $("#selectBranchCol").attr("hidden", true);
	            $("#selectBranchLbl").attr("hidden", true);
	            $("#selectBranch").attr("hidden", true);

	        } else if($("#userRole").val() == 177 || $("#userRole").val() == 179 || $("#userRole").val() == 180 || // Cody Support
	                $("#userRole").val() == 200 || $("#userRole").val() == 252 || $("#userRole").val() == 253 || // Cody Planning
	                $("#userRole").val() == 250 || $("#userRole").val() == 256
	               ) {

	            var brnch = "${branch}";
	            $('#selectBranch option[value="' + brnch +'"] ').attr("selected", true);

	            $('#memTypeCom option[value="2"] ').attr("selected", true);
	            $('#memTypeCom').attr("disabled", true);

	            $("#memLevelCom").attr("disabled", false);
	            $("#memLevelCom option[value='4']").attr("selected", true); // Temporary default to Cody only

	            if($("#userRole").val() == 177 || $("#userRole").val() == 256) {
	                $("#selectBranch").attr("disabled", true);
	            }
	        } else if($("#userRole").val() == 342 || $("#userRole").val() == 343 || $("#userRole").val() == 344){// Homecare Department

	            var brnch = "${branch}";
	            $('#selectBranch option[value="' + brnch +'"] ').attr("selected", true);

	            $('#memTypeCom option[value="7"] ').attr("selected", true);
	            $('#memTypeCom').attr("disabled", true);

	            $('#memLevelCom').attr("disabled", false);

	        }

	        createAUIGrid();
	        AUIGrid.setSelectionMode(myGridID, "singleRow");

	        AUIGrid.bind(myGridID, "cellClick", function(event) {
	            memberid = AUIGrid.getCellValue(myGridID, event.rowIndex, "memcode");
	            joinDt = AUIGrid.getCellValue(myGridID, event.rowIndex, "joinDt");
	            cnfmDt = AUIGrid.getCellValue(myGridID, event.rowIndex, "cnfmDt");
	            agmtStus = AUIGrid.getCellValue(myGridID, event.rowIndex, "agmtStus");
	        });
	    }
	 else{
		 var memType = "${memType}";
		  if(memType == 1 || memType == 2 || memType ==7) {
	            $("#memTypeCom > option[value='" + memType +"']").attr("selected", true);
	        }

	        $("#code").val("${memCode}");

	        Common.ajax("GET", "/logistics/agreement/getMemberInfo", {code : "${memCode}", memTypeCom : memType}, function(result) {
	            $("#name").val(result.name);
	            $("#icNum").val(result.nric);
	            $("#deptCode").val(result.deptCode);
	            $("#grpCode").val(result.grpCode);
	            $("#memStusCmb option[value='" + result.stus + "']").attr("selected", true);
	            $("#memLevelCom option[value='" + result.memLvl + "']").attr("selected", true);
	            $("#joinDt").val(result.joinDt);
	            $("#cnfmDt").val(result.cnfmDt);

	            if(memType == 1) {
	                $("#branchPeriodRow").attr("hidden",true);
	                $("#promoDt").val(result.promoDt);
	            }
	        });

	        $("#memTypeCom").attr("disabled", true);
	        $("#memStusCmb").attr("disabled", true);
	        $("#memLevelCom").attr("disabled", false);
	        $("#name").attr("disabled", false);
	        $("#icNum").attr("disabled", false);
	        $("#code").attr("disabled", false);
	        $("#deptCode").attr("disabled", false);
	        $("#grpCode").attr("disabled", false);
	        $("#orgCode").attr("disabled", false);
	        createAUIGrid();
	 }
}

function fn_onChgMemType() {

    var memType = $("#memTypeCom").val();

    if(memType != '') {
        // Member Level
        doGetCombo('/logistics/agreement/getMemLevel', memType, '' ,'memLevelCom' , 'S');
        $("#memLevelCom").attr("disabled", false);
        $('#memLevelCom option[value="4"] ').attr("selected", true);

        if(memType == "2") {
            $("#selectBranch").attr("disabled", false);
        }
    } else {
        $("#memLevelCom").empty();
        $("#memLevelCom").append("<option value=''>Choose One</option>");
        $("#memLevelCom").attr("disabled", true);

    }
}

function fn_onChgMemLvl() {
    var memType = $("#memTypeCom").val();
    var memLvl = $("#memLevelCom").val();

    if(memType == "1" && memLvl == "4") {
        //$("#startDt").attr("disabled", true);
    } else {
        $("#startDt").attr("disabled", false);
    }
}

function fn_searchMemberEAgreement() {

	if($("#startDt").val() == "" && $("#endDt").val() == ""){
	    if($("#code").val() == "" && $("#icNum").val() == "") {
	        Common.alert("Member Code/NRIC is required.");
	        return false;
	    }

	    if($("#memTypeCom").val() == "") {
	        Common.alert("Please select one member type.");
	        return false;
	    }
	}
    var obj = {
        memCode : $("#code").val(),
        name : $("#name").val(),
        icNum : $("#icNum").val(),
        memTypeCom : $("#memTypeCom").val(),
        memLevelCom : $("#memLevelCom").val(),
        memStusCmb : $("#memStusCmb").val(),
        deptCode : $("#deptCode").val(),
        grpCode : $("#grpCode").val(),
        orgCode : $("#orgCode").val(),
        selectBranch : $("#selectBranch").val(),
        startDt: $("#startDt").val(),
        endDt: $("#endDt").val()
    };

    Common.ajax("GET", "/logistics/agreement/selectEAgreementHistoryList.do", obj, function(result) {

        console.log(result);
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_ExcelDownload(){
    GridCommon.exportTo("grid_wrap_memList", "xlsx", "E-Agreement History List");
}

function fn_downloadAgreement() {
	var aplctnId, memCode,cnfm,memType,memLvl,cnfmDt,rptFileName,joinDt;
    var option = {
        isProcedure : true
    };

	if(AUIGrid.getSelectedItems(myGridID).length > 0){
		aplctnId = AUIGrid.getSelectedItems(myGridID)[0].item.aplctnId;
        memCode = AUIGrid.getSelectedItems(myGridID)[0].item.aplicntCode;
        cnfm = AUIGrid.getSelectedItems(myGridID)[0].item.cnfm;
        memType = AUIGrid.getSelectedItems(myGridID)[0].item.aplicntType;
        memLvl = AUIGrid.getSelectedItems(myGridID)[0].item.memLvl;
        cnfmDt = AUIGrid.getSelectedItems(myGridID)[0].item.rptCnfmDt;
        rptFileName = AUIGrid.getSelectedItems(myGridID)[0].item.rptFileName;
        joinDt = AUIGrid.getSelectedItems(myGridID)[0].item.joinDt;

        if(cnfm == 0){
    		Common.alert("Current record has not been signed yet. Download is not allowed.")
    		return false;
        }

        $("#v_memCode").val(memCode);

        if(memType == "1")
        {
        	//Health Planner Agreement

        	if(memLvl < "4" && memLvl != "") {
        		if($("#startDt").val() == "" && $("#endDt").val() == ""){
        			Common.alert("Generating HM,SM,GM agreement requires Contract Period to be filled.")
        			return false;
        		}
                $("#v_contractStartDt").val($("#startDt").val());
                $("#v_contractEndDt").val($("#endDt").val());
                $("#v_signedDt").val(cnfmDt);
        	}
            $("#reportFileName").val("/organization/agreement/" + rptFileName);

            var rptDlFlNm = rptFileName.split(".");
            $("#reportDownFileName").val(rptDlFlNm[0] + "_" + memCode);

            Common.report("agreementReport", option);
        }
        else if(memType =="2"){
        	//Cody Agreement

			console.log(cnfmDt.substring(6) + "-" + cnfmDt.substring(3, 5) + "-" + cnfmDt.substring(0, 2));

            $("#v_signedDt").val(cnfmDt);
            $("#v_contractStartDt").val(cnfmDt.substring(6) + "-" + cnfmDt.substring(3, 5) + "-" + cnfmDt.substring(0, 2));


            $("#reportFileName").val("/organization/agreement/" + rptFileName);
            $("#reportDownFileName").val("CodyAgreement_" + memCode);
            Common.report("agreementReport", option);
        }
        else if(memType =="7"){
        	//Home Technician Agreement

			var cnfmDtSplit = cnfmDt.split("/");

			var cnfmDtFormat = new Date(cnfmDtSplit[2] + "-" + cnfmDtSplit[1] + "-" + cnfmDtSplit[0]);
            $("#v_contractStartDt").val(cnfmDtFormat);
        	//Always Y to get ORG0003D confirm date
        	$("#v_currentSts").val("Y");

            if(memLvl == "4") {
                $("#reportFileName").val("/organization/agreement/HTAgreement_2022v1.rpt");
                $("#reportDownFileName").val("HTAgreement_" + memCode);
            } else {
                $("#reportFileName").val("/organization/agreement/HTMAgreement_2022v1.rpt");
                $("#reportDownFileName").val("HTMAgreement_" + memCode);
            }
            Common.report("agreementReport", option);
        }
    }
	else{
		Common.alert("Please select a history record");
		return false;
	}
}
</script>

<section id="content">
    <!-- content start -->
    <ul class="path">
        <li><img
            src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
            alt="Home" /></li>
        <li>e-Agreement</li>
    </ul>

    <aside class="title_line">
        <!-- title_line start -->
        <h2>e-Agreement History</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_searchMemberEAgreement();"><span class="search"></span>Search</a></p></li>
	        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
	            <li><p class="btn_blue"><a href="javascript:fn_downloadAgreement();">Download</a></p></li>
	        </c:if>
        </ul>
    </aside>

    <section class="search_table">
        <!-- search_table start -->
        <form action="#" id="searchForm" method="post">
		    <input type="hidden" id="userRole" name="userRole" value="${userRole} " />
		    <input type="hidden" id="promoDt" name="promoDt" value="" />
		    <input type="hidden" id="joinDt" name="joinDt" />
		    <input type="hidden" id="cnfmDt" name="cnfmDt" />
            <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width: 150px" />
                    <col style="width: *" />
                    <col style="width: 150px" />
                    <col style="width: *" />
                    <col style="width: 150px" />
                    <col style="width: *" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Mem. Code</th>
                        <td><input type="text" title="Code" placeholder="" class="w100p" id="code" name="code" /></td>
                        <th scope="row">Mem. Name</th>
                        <td><input type="text" title="Name" placeholder="" class="w100p" id="name" name="name" /></td>
                        <th scope="row">IC Number</th>
                        <td><input type="text" title="IC Number" placeholder="" class="w100p" id="icNum" name="icNum" /></td>
                    </tr>
                    <tr>
                        <th scope="row">Member Type<span class="must">*</span></th>
                        <td><select class="w100p" id="memTypeCom" name="memTypeCom" onChange="javascript : fn_onChgMemType()">
                                <option value="" selected>Select Account</option>
                                <option value="1">Health Planner</option>
                                <option value="2">Cody</option>
                                <option value="7">Homecare Technician</option>
                        </select></td>
                        <th scope="row">Member Level</th>
                        <td><select class="w100p" id="memLevelCom" name="memLevelCom" onChange="javascript : fn_onChgMemLvl()">
                                <option value="">Choose One</option>
                                <c:forEach var="list" items="${memLevel}" varStatus="status">
                                    <option value="${list.codeId}">${list.codeName}</option>
                                </c:forEach>
                        </select></td>
                        <th scope="row">Status</th>
                        <td><select class="w100p" id="memStusCmb" name="memStusCmb"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Department Code</th>
                        <td><input type="text" class="w100p" id="deptCode" name="deptCode" value="${deptCode}" /></td>
                        <th scope="row">Group Code</th>
                        <td><input type="text" class="w100p" id="grpCode" name="grpCode" value="${grpCode}" /></td>
                        <th scope="row">Organization Code</th>
                        <td><input type="text" class="w100p" id="orgCode" name="orgCode" value="${orgCode}" /></td>
                    </tr>
                    <tr id="branchPeriodRow">
                        <th scope="row" id="selectBranchLbl">Branch</th>
                        <td id="selectBranchCol">
                            <!-- <span><c:out value="${memberView.c4} - ${memberView.c5} " /></span>-->
                            <select class="w100p" id="selectBranch" name="selectBranch">
                                <option value="">Choose One</option>
                                <c:forEach var="list" items="${branchList}" varStatus="status">
                                    <option value="${list.brnchId}">${list.branchCode}-
                                        ${list.branchName}</option>
                                </c:forEach>
                        </select>
                        </td>
                        <th scope="row" ></th>
                        <td></td>
                        <th scope="row" ></th>
                        <td></td>
                     </tr>
                     <tr>
                        <th scope="row" id="contractPeriodLbl">Contract Period</th>
                        <td>
                            <div class="date_set w100p">
                                <!-- date_set start -->
                                <p>
                                    <input type="text" title="Contract Start Date"
                                        placeholder="DD/MM/YYYY" class="j_date" id="startDt"
                                        name="startDt" />
                                </p>
                                <span><spring:message code="webInvoice.to" /></span>
                                <p>
                                    <input type="text" title="Contract End Date"
                                        placeholder="DD/MM/YYYY" class="j_date" id="endDt"
                                        name="endDt" />
                                </p>
                            </div> <!-- date_set end -->
                        </td>
                        <th scope="row" ></th>
                        <td></td>
                        <th scope="row" ></th>
                        <td></td>
                     </tr>
                </tbody>
            </table>
            <!-- table end -->

        </form>
    </section>
    <!-- search_table end -->

    <aside class="link_btns_wrap">
        <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
        <dl class="link_list">
            <dt><spring:message code="sal.title.text.link" /></dt>
            <dd>
                <ul class="btns">
                </ul>
                <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
            </dd>
        </dl>
    </aside>

   	<ul class="right_btns" style="margin-top:5px;">
	      <li><p class="btn_grid"><a id="mainBt_dw"onclick="javascript:fn_ExcelDownload();" >Excel Dw</a></p></li>
    </ul>

    <article class="grid_wrap">
        <div id="grid_wrap_memList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
    </article>

	<form id="agreementReport" name="agreementReport">
        <input type="hidden" id="tmpRptNm" name="tmpRptNm" value="" />
        <input type="hidden" id="reportFileName" name="reportFileName" value="" />
        <input type="hidden" id="viewType" name="viewType" value="PDF" />
        <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
        <input type="hidden" id="v_memCode" name="v_memCode" value="" />
        <input type="hidden" id="v_contractStartDt" name="v_contractStartDt" value="" />
        <input type="hidden" id="v_contractEndDt" name="v_contractEndDt" value="" />
        <input type="hidden" id="v_currentSts" name="v_currentSts" value="" />
        <input type="hidden" id="v_signedDt" name="v_signedDt" value="" />
    </form>
</section>
<!-- content end -->
