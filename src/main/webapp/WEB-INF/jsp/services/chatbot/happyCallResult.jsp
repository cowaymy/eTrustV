<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

	var happyCallResultGridId;
	var memType = '${SESSION_INFO.userTypeId}';  //1=HP, 2=CD, 4=Staff, 7=HT
	var memLevel = '${SESSION_INFO.memberLevel}';
	var userDefine1 = "${PAGE_AUTH.funcUserDefine1}";
	var userPrint = "${PAGE_AUTH.funcPrint}";

//	function createAUIGrid() {
		var happyCallResultColumnLayout = [{
			dataField : "transactionId",
	        headerText : "Transaction ID",
	        visible: false
		},
		/* {
			dataField : "callTypeDesc",
		    headerText : "Call Type"
		},  */
		{
		    dataField : "codyCode",
		    headerText : "Cody Code"
		}, {
		    dataField : "codyName",
		    headerText : "Cody Name"
		}, {
		    dataField : "deptCode",
		    headerText : "Department"
		},{
			dataField : "grpCode",
	        headerText : "Group Code",
	        visible: false
		}, {
			dataField : "orgCode",
	        headerText : "Organization Code",
	        visible: false
		}, {
		    dataField : "pcnt",
		    headerText : "HS Survey Score"
		}, {
		    dataField : "surveyList",
		    headerText : "Survey List",
		    //style : cellStyleNonView,
	        renderer : {
	            type : "ButtonRenderer",
	            labelText : "View More",
	            onclick : function(rowIndex, columnIndex, value, item) {
	            	console.log(rowIndex);
	                $("#codeId").val(item.transactionId);
	                $("#selectedMemCode").val(item.codyCode);
	                $("#selectedDeptCode").val(item.deptCode);
	                $("#selectedGrpCode").val(item.grpCode);
	                $("#selectedOrgCode").val(item.orgCode);

	                Common.popupDiv("/services/chatbot/selectHappyCallResultHistList.do", $("#searchForm").serializeJSON(), null, true, "happyCallResultHistoryPop");
	            }
	        },
	        editable : false
		}];

		var happyCallResultGridPros = {
		    usePaging : true,
		    pageRowCount : 40,
		    selectionMode : "singleCell",
		    showRowCheckColumn : false,
		    showRowAllCheckBox : false
		};

		//happyCallResultGridId = AUIGrid.create("#grid_wrap_happyCall", happyCallResultColumnLayout, happyCallResultGridPros);
	//}

	$(document).ready(function () {
		happyCallResultGridId = AUIGrid.create("#grid_wrap_happyCall", happyCallResultColumnLayout, happyCallResultGridPros);

		fn_setToDay();
		$("#userDefine1").val(userDefine1);
		$("#userPrint").val(userPrint);

		/* AUIGrid.bind(happyCallResultGridId, "cellClick", function( event ) {
			console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
		}); */

		//Auto Populate Dept/Grp/Org Code based on Login ID
		if(memType == "1" || memType == "2" || memType == "3" || memType == "7" ){
			$("#isAc").val("${isAc}");

            if(memLevel=="1"){

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

            }else if(memLevel=="2"){

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

            }else if(memLevel=="3"){

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

                $("#deptCode").val("${deptCode}");
                $("#deptCode").attr("class", "w100p readonly");
                $("#deptCode").attr("readonly", "readonly");

            }else if(memLevel=="4"){

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

                $("#deptCode").val("${deptCode}");
                $("#deptCode").attr("class", "w100p readonly");
                $("#deptCode").attr("readonly", "readonly");

                console.log("Member Code: " + memLevel);
                $("#agentCode").val("${memCode}");
                $("#agentCode").attr("class", "w100p readonly");
                $("#agentCode").attr("readonly", "readonly");

            }
        }


	});

	function fn_searchHappyCallResultList() {
		if(fn_checkMandatory()){
			Common.ajax("GET", "/services/chatbot/selectHappyCallResultList.do", $("#searchForm").serialize(), function(result) {
	            AUIGrid.setGridData(happyCallResultGridId, result);
	        });
		}
    }

	function fn_checkMandatory() {
		if(FormUtil.isEmpty($("#periodMonth").val())) {
            Common.alert("Please select Period Month.");
            return false;
        }
		return true;
	}

	function onChangeMemType(val){
		console.log("testing: " + val);
		if($("#memTyp").val() == "ACI"){
			$("#isAc").val("1");
		}else{
			$("#isAc").val("0");
		}
		console.log($("#memTyp").val());
	}

	function fn_setToDay() {
	    var today = new Date();

	    var mm = today.getMonth() + 1;
	    var yyyy = today.getFullYear();

	    if(mm < 10){
	        mm = "0" + mm
	    }

	    today = mm + "/" + yyyy;

	    $("#periodMonth").val(today)
	}

	function fn_clear() {

		fn_setToDay();
		if(memType == "1" || memType == "2" || memType == "3" || memType == "7" ){

			if(memLevel=="1"){

                $("#grpCode").val("");
                $("#deptCode").val("");
                $("#agentCode").val("");

            }else if(memLevel=="2"){

            	$("#deptCode").val("");
                $("#agentCode").val("");

            }else if(memLevel=="3"){

            	$("#agentCode").val("");

            }else if(memLevel=="4"){

            }
		}else{

			$("#orgCode").val("");
			$("#grpCode").val("");
            $("#deptCode").val("");
            $("#agentCode").val("");
		}
	}

</script>



<form id='cForm' name='cForm'>
</form>
<section id="content">
  <!-- content start -->
  <ul class="path">
    <li>Service</li>
    <li>Happy Call Result</li>
  </ul>
  <aside class="title_line">
    <h2>Happy Call Result</h2>
    <ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li><p class="btn_blue"><a href="#" onclick="javascript:fn_searchHappyCallResultList();"><span class="search"></span>Search</a></p></li>
        <li><p class="btn_blue"><a href="#" onClick="javascript:fn_clear()"><span class="clear"></span>Clear</a></p></li>
      </c:if>
      <!-- <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
    </ul>
  </aside>

  <section class="search_table">
    <form id="searchForm" action="#" method="post">
      <input type="hidden" name="isAc" id="isAc"/> <!-- ORG0001D.IS_AC -->
      <input type="hidden" name="selectedMemCode" id="selectedMemCode"/>
      <input type="hidden" name="selectedDeptCode" id="selectedDeptCode"/>
      <input type="hidden" name="selectedGrpCode" id="selectedGrpCode"/>
      <input type="hidden" name="selectedOrgCode" id="selectedOrgCode"/>
      <input type="hidden" name="userDefine1" id="userDefine1"/>
      <input type="hidden" name="userPrint" id="userPrint"/>

      <table class="type1">
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
            <%-- <th scope="row">Call Type</th>
            <td>
              <select class="w100p" id="callTypeId" name="callTypeId">
                <c:forEach var="list" items="${callType}" varStatus="status">
                    <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>

            </td> --%>
            <th scope="row">Agent Type</th>
            <td>
              <select id="memTyp" name="memTyp" class="w100p" onchange="onChangeMemType(this.value)">
                <option value="2">CD - Cody</option>
                <option value="3">CT - Coway Technician</option>
                <option value="7">HT - Homecare Technician</option>
                <option value="5758">DT - Delivery Technician</option>
                <option value="6672">LT - Logistics Technician</option>
                <option value="ACI">ACI</option>
              </select>
            </td>
            <th scope="row">Agent Code</th>
            <td>
              <input id="agentCode" name="agentCode" type="text" title="" placeholder="Agent Code" class="w100p" />
            </td>
            <th scope="row">Period Month <span class="must">*</span></th>
            <td>
              <input type="text" title="Period Month" placeholder="MM/YYYY" class="j_date2 w100p" id="periodMonth" name="periodMonth"/>
            </td>
          </tr>
          <tr>
            <th scope="row">Department Code</th>
            <td>
              <!-- <input type="text" title="" id="deptCode" name="deptCode" onkeyup="this.value = this.value.toUpperCase();" placeholder="Department Code" class="w100p" /> -->
              <input type="text" title="" id="deptCode" name="deptCode" placeholder="Department Code" class="w100p" />
            </td>
            <th scope="row">Group Code</th>
            <td>
              <!-- <input type="text" title="" id="grpCode" name="grpCode" onkeyup="this.value = this.value.toUpperCase();" placeholder="Group Code" class="w100p" /> -->
              <input type="text" title="" id="grpCode" name="grpCode" placeholder="Group Code" class="w100p" />
            </td>
            <th scope="row">Organization Code</th>
            <td>
              <!-- <input type="text" title="" id="orgCode" name="orgCode" onkeyup="this.value = this.value.toUpperCase();" placeholder="Organization Code" class="w100p" /> -->
              <input type="text" title="" id="orgCode" name="orgCode" placeholder="Organization Code" class="w100p" />
            </td>
          </tr>

        </tbody>
      </table>
    </form>
  </section>

  <br/>

  <section class="search_result">
<%--     <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li>
                <p class="btn_grid"><a href="#" onClick="fn_excelDown()">Generate</a></p>
            </li>
        </c:if>
    </ul> --%>

    <article class="grid_wrap">
        <div id="grid_wrap_happyCall" style="width: 100%; height: 300px; margin: 0 auto;"></div>
    </article>
  </section>

  <br/>
  <br/>
</section>