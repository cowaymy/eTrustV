<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">

.my-yellow-style {
    background:#FFE400;
    font-weight:bold;
    color:#22741C;
}

</style>
<script type="text/javaScript">
var myGridID;
var grpOrgList = new Array(); // Group Organization List
var orgList = new Array(); // Organization List
var selRowIndex;
var userType = '${SESSION_INFO.userTypeId}';

var selectedGridValue;

function fn_memberListSearch(){
    selRowIndex = null;

    var jsonObj =  {
    	promoDisHismemTypeCom : $("#promoDisHismemTypeCom").val(),
    	promoDisHisCode : $("#promoDisHisCode").val(),
    	promoDisHisName : $("#promoDisHisName").val(),
    	promoDisHisIcNum : $("#promoDisHisIcNum").val(),
    	promoDisHisContact : $("#promoDisHisContact").val(),
        promoDisHisPosition : $("#position").val(),
        promoDisHisSponsor : $("#promoDisHisSponsor").val(),
        orgCodeHd : $("#orgCodeHd").val(),
        grpCodeHd : $("#grpCodeHd").val(),
        deptCodeHd : $("#deptCodeHd").val()
    }

    console.log("SearchPromoDisHistory");
    var isValid = false;

    if(FormUtil.isEmpty($("#promoDisHisCode").val())){

          if (  $("#grpCodeHd").val() =="" ){

        	  if (  $("#deptCodeHd").val() =="" ){
                  isValid = true;
              }
          }
      }

    if(isValid == true){
    	Common.alert("<spring:message code='sal.alert.msg.youMustKeyInatLeastGrpCodeDeptCodeMemCode' />");
    	 return;
    }

    Common.ajax("GET", "/organization/promoDisHistorySearch", jsonObj, function(result) {
        AUIGrid.setGridData(myGridID, result);
    });


    AUIGrid.setProp(myGridID, "rowStyleFunction", function(rowIndex, item){
    	if (item.main == "1") {
    		   return "my-yellow-style";
    	}else{
            return "";
        }
    });

}

function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap_promoDisHistoryList", "xlsx", "eHPMemberList");
}

//Start AUIGrid --start Load Page- user 1st click Member
$(document).ready(function() {

	if("${SESSION_INFO.memberLevel}" =="1"){

        $("#orgCodeHd").val("${orgCodeHd}");
        $("#orgCodeHd").attr("class", "w100p readonly");
        $("#orgCodeHd").attr("readonly", "readonly");

    }else if("${SESSION_INFO.memberLevel}" =="2"){

        $("#orgCodeHd").val("${orgCodeHd}");
        $("#orgCodeHd").attr("class", "w100p readonly");
        $("#orgCodeHd").attr("readonly", "readonly");

        $("#grpCodeHd").val("${grpCodeHd}");
        $("#grpCodeHd").attr("class", "w100p readonly");
        $("#grpCodeHd").attr("readonly", "readonly");

    }else if("${SESSION_INFO.memberLevel}" =="3"){

        $("#orgCodeHd").val("${orgCodeHd}");
        $("#orgCodeHd").attr("class", "w100p readonly");
        $("#orgCodeHd").attr("readonly", "readonly");

        $("#grpCodeHd").val("${grpCodeHd}");
        $("#grpCodeHd").attr("class", "w100p readonly");
        $("#grpCodeHd").attr("readonly", "readonly");

        $("#deptCodeHd").val("${deptCodeHd}");
        $("#deptCodeHd").attr("class", "w100p readonly");
        $("#deptCodeHd").attr("readonly", "readonly");

    }else if("${SESSION_INFO.memberLevel}" =="4"){

        $("#orgCodeHd").val("${orgCodeHd}");
        $("#orgCodeHd").attr("class", "w100p readonly");
        $("#orgCodeHd").attr("readonly", "readonly");

        $("#grpCodeHd").val("${grpCodeHd}");
        $("#grpCodeHd").attr("class", "w100p readonly");
        $("#grpCodeHd").attr("readonly", "readonly");

        $("#deptCodeHd").val("${deptCodeHd}");
        $("#deptCodeHd").attr("class", "w100p readonly");
        $("#deptCodeHd").attr("readonly", "readonly");

        $("#promoDisHisCode").val("${promoDisHisCode}");
        $("#promoDisHisCode").attr("class", "w100p readonly");
        $("#promoDisHisCode").attr("readonly", "readonly");

        $("#promoDisHismemTypeCom").val("${promoDisHismemTypeCom}");
        $("#promoDisHismemTypeCom").attr("class", "w100p readonly");
        $("#promoDisHismemTypeCom").attr("readonly", "readonly");


        $("#memLvl").attr("class", "w100p readonly");
        $("#memLvl").attr("readonly", "readonly");

    }

    createAUIGrid();

     $("#position").attr("disabled",true);

     /* if($("#userRole").val() == "130" || $("#userRole").val() == "137" // Administrator
       || $("#userRole").val() == "141" || $("#userRole").val() == "142" || $("#userRole").val() == "160" // HR
     ) {

     } */
 });

function createAUIGrid() {
        //AUIGrid
        var columnLayout = [{
        //hide column
            dataField : "codename",
            headerText : "Type Name",
            editable : true,
            visible : false,
            width : 130
        }, {
            dataField : "memberid",
            headerText : "MemberID",
            editable : false,
            visible : false,
            width : 130
        },{
            dataField : "memCode",
            headerText : "Member Code",
            editable : false,
            width : 130
        },{
            dataField : "positionName",
            headerText : "Position Desc",
            editable : false,
            width : 150
        }, {
            dataField : "memberCodeHistory",
            headerText : "Member Code History",
            editable : false,
            width : 180
        },{
            dataField : "name",
            headerText : "Name",
            editable : false,
            width : 250
        },{
            dataField : "gmcode",
            headerText : "GM Code",
            editable : false,
            width : 130
        },{
            dataField : "smcode",
            headerText : "SM Code",
            editable : false,
            width : 130
        },{
            dataField : "hmcode",
            headerText : "HM Code",
            editable : false,
            width : 130
        },{
            dataField : "motherManagerCode",
            headerText : "Mother Manager Code",
            editable : false,
            width : 180
        },{
            dataField : "motherManagerName",
            headerText : "Mother Manager Name",
            editable : false,
            width : 180
        },{
            dataField : "sponsCode",
            headerText : "Sponsor Code",
            editable : false,
            width : 130
        },{
            dataField : "promotionDate",
            headerText : "Promotion Date",
            editable : false,
            width : 150
        },{
            dataField : "discontinueDate",
            headerText : "Discontinue Date",
            editable : false,
            width : 150
        }];

        var gridPros = {
            usePaging           : true,
            pageRowCount        : 20,
            editable            : false,
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
            // selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,
            skipReadonlyColumns : true,
            wrapSelectionMove   : true,
            showRowNumColumn    : true
        };

        myGridID = AUIGrid.create("#grid_wrap_promoDisHistoryList", columnLayout, gridPros);
    }

function fn_searchPosition(selectedData){
    $("#position option").remove();
      if(selectedData == "2" || selectedData =="3" || selectedData =="1" || selectedData =="7" || selectedData =="5758"){
           $("#position").attr("disabled",false);   /*position button enable*/
           Common.ajax("GET",
                    "/organization/positionList.do",
                    "memberType="+selectedData,
                    function(result) {
                        $("#position").append("<option value=''>Select Position</option> " );
                        for(var idx=0; idx < result.length ; idx++){
                            $("#position").append("<option value='" +result[idx].positionLevel+ "'> "+result[idx].positionName+ "</option>");
                        }
                    }
           );
       }else{
           /*position button disable*/
           $("#position").attr("disabled",true);
           /* If you want to set position default value remove under comment.*/
           $("#position").append("<option value=''>Select Account</option> " );

       }
}

</script>

<!-- --------------------------------------DESIGN------------------------------------------------ -->

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Organization</li>
        <li>Member</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Promotion Discontinue History</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_memberListSearch();"><span class="search"></span>Search</a></p></li>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
        <form action="#" id="promoDisHisSearchForm" method="post">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Member Type</th>
                        <td>
                        <select class="w100p" id="promoDisHismemTypeCom" name="promoDisHismemTypeCom" onchange="fn_searchPosition(this.value)" >
                             <option value="" selected>Select Account</option>
                             <c:forEach var="list" items="${memberType }" varStatus="status">
                              <option value="${list.codeId}">${list.codeName}</option>
                               </c:forEach>
                        </select>
                        </td>
                        <th scope="row">Code</th>
                        <td>
                        <input type="text" title="Code" placeholder="" class="w100p" id="promoDisHisCode" name="promoDisHisCode" />
                        </td>
                        <th scope="row">Name</th>
                        <td>
                        <input type="text" title="Name" placeholder="" class="w100p" id="promoDisHisName" name="promoDisHisName" />
                        </td>
                        <th scope="row">IC Number</th>
                        <td>
                        <input type="text" title="IC Number" placeholder="" class="w100p" id="promoDisHisIcNum" name="promoDisHisIcNum" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Contact No</th>
                        <td>
                        <input type="text" title="Contact No" placeholder="" class="w100p" id="promoDisHisContact" name="promoDisHisContact"/>
                        </td>
                        <th scope="row">Position</th>
					    <td>
					    <select class="w100p" id="position" name="position">
					        <option value="" selected>Select Account</option>
					        <c:forEach var="list" items="${position}" varStatus="status">
					            <option value="${list.positionLevel}">${list.positionName}</option>
					        </c:forEach>
					    </select>
					    </td>
					    <th scope="row">Sponsor's Code</th>
					    <td>
					     <input type="text" title="Sponsor's Code" placeholder="" class="w100p" id="promoDisHisSponsor" name="promoDisHisSponsor"/>
					    </td>
					    <th scope="row"></th>
					    <td>
					    </td>
                    </tr>
	                <tr>
				        <th scope="row">Org Code</th>
				        <td><input type="text" title="orgCode" id="orgCodeHd" name="orgCodeHd" placeholder="Org Code" class="w100p" /></td>
				        <th scope="row">Grp Code</th>
				        <td><input type="text" title="grpCode" id="grpCodeHd" name="grpCodeHd"  placeholder="Grp Code" class="w100p"/></td>
				        <th scope="row">Dept Code</th>
				        <td><input type="text" title="deptCode" id="deptCodeHd" name="deptCodeHd"  placeholder="Dept Code" class="w100p"/></td>
				        <th scope="row"></th>
				        <td></td>
				   </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    </section><!-- search_table end -->

    <form id="eHpApplicantValidateForm" method="post">
        <div style="display:none">
            <input type="text" name="aplcntCode"  id="eHPaplcntCode"/>
            <input type="text" name="aplcntNRIC"  id="eHPaplcntNRIC"/>
        </div>
    </form>

    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid"><a href="javascript:fn_excelDown();">GENERATE</a></p></li>
            </c:if>
        </ul>

        <article class="grid_wrap">
           <div id="grid_wrap_promoDisHistoryList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
        </article><!-- grid_wrap end -->
    </section><!-- search_result end -->
</section><!-- content end -->

<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
    <p>Information Message Area</p>
</aside><!-- bottom_msg_box end -->
