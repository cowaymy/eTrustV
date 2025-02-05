<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
/* var myGridID4;

var oArea = '<spring:message code="sys.area" />';
var oCity = '<spring:message code="sys.city" />';
var oState = '<spring:message code="sys.state" />';
var oPostcode = '<spring:message code="sys.title.postcode" />';
var oCountry = '<spring:message code="sys.country" />';
var oCountrycode = '<spring:message code="sys.title.countrycode" />'; */


/* var columnLayout4=[
 {dataField:"areaId", headerText:'<spring:message code="sys.areaId" />', width: 110},
 {dataField:"area", headerText:'<spring:message code="sys.area" />', width: 180},
 {dataField:"postcode", headerText:'<spring:message code="sys.title.postcode" />', width: 85},
 {dataField:"city", headerText:'<spring:message code="sys.city" />', width: 85},
 {dataField:"state", headerText:'<spring:message code="sys.state" />', width: 85},
 {dataField:"country", headerText:'<spring:message code="sys.country" />', width: 85},
 {dataField:"countrycode", headerText:'<spring:message code="sys.title.countrycode" />', width: 100},
 {dataField:"statusId", headerText:'<spring:message code="sys.status" />', width: 85, editable : false},
 {dataField:"id", headerText:'<spring:message code="sys.source" />', editable : false},
]; */
var grdOriAuth = "";
var grdReqAuth = "";
var grdReqMenuMapping = "";

var gridAuthColumnLayout =
[
     /* PK , rowid 용 칼럼*/
     {
         dataField : "rowId",
         dataType : "string",
         visible : false
     },
    {
        dataField : "authCode",
        /* dataType : "string", */
        headerText : "Auth Code",
        width : "30%",
    },
    {
        dataField : "authName",
        headerText : "Auth Name",
        style : "aui-grid-user-custom-left"
    }
    /* ,
    {
        dataField : "chkAll",
        headerText : " ",
        width:"8%",
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Y", // true, false 인 경우가 기본
            unCheckValue : "N"
        }
    }, */

];

var options =
{
        usePaging : true, //페이징 사용
        showRowNumColumn : false, // 순번 칼럼 숨김
/*         useGroupingPanel : false, //그룹핑 숨김
        applyRestPercentWidth  : false,
        rowIdField : "rowId", // PK행 지정
        selectionMode : "multipleRows",
        editBeginMode : "click", */
        showRowCheckColumn : true
        ,Editable : false
};

var gridReqAuthColumnLayout =
	[
	     /* PK , rowid 용 칼럼*/
	     {
	         dataField : "rowId",
	         dataType : "string",
	         visible : false
	     },
	    {
	        dataField : "authCode",
	        /* dataType : "string", */
	        headerText : "Auth Code",
	        width : "30%"
	    },
	    {
	        dataField : "authName",
	        headerText : "Auth Name",
	        style : "aui-grid-user-custom-left"
	    }

	];

var reqOptions =
{
        editable : false,
        usePaging : true, //페이징 사용
        //useGroupingPanel : false, //그룹핑 숨김
        showRowNumColumn : false, // 순번 칼럼 숨김
        //applyRestPercentWidth  : false,
        //rowIdField : "rowId", // PK행 지정
        //showStateColumn: false,
        showRowCheckColumn : true,
        /* selectionMode : "multipleRows",
        editBeginMode : "click", // 편집모드 클릭 */
        /* aui 그리드 체크박스 옵션*/
        softRemoveRowMode : false


};

var gridMenuMappingColumnLayout =
	[
	     /* PK , rowid 용 칼럼*/
	     {
	         dataField : "rowId",
	         dataType : "string",
	         visible : false
	     },
	    {
	        dataField : "menuLvl",
	        /* dataType : "string", */
	        headerText : "Lvl",
	        editable : false, // 추가된 행인 경우만 수정 할 수 있도록 editable : true 로 설정 (cellEditBegin 이벤트에서 제어함)
	        width : "8%"
	    },
	    {
	        dataField : "menuName",
	        headerText : "Menu Name",
	        width : "30%",
	        editable : false,
	        style : "aui-grid-user-custom-left"
	    },
	    {
	        dataField : "pgmName",
	        headerText : "Program Name",
	        width : "30%",
	        editable : false,
	        style : "aui-grid-user-custom-left"
	    },
	    {
	        dataField : "pgmTrnName",
	        headerText : "Transaction",
	        width : "20%",
	        editable : false,
	        style : "aui-grid-user-custom-left"
	    },
	    {
	        dataField : "funcYn",
	        headerText : "<input type='checkbox' id='allCheckbox' style='width:15px;height:15px;''>",
	        editable : true,
	        renderer : {
	            type : "CheckBoxEditRenderer",
	            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	            checkValue : "Y", // true, false 인 경우가 기본
	            unCheckValue : "N",
	            styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
	                if(item.existYn == "Y") {
	                    return "disable-check-style";
	                }
	                return null;
	            },
	            // 체크박스 disabled 함수
	            disabledFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
	                if(item.existYn == "Y")
	                    return true; // true 반환하면 disabled 시킴
	                return false;
	            }
//	          // 체크박스 Visible 함수
//	          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
//	              if(item.charge == "Anna")
//	                  return false; // 책임자가 Anna 인 경우 체크박스 표시 안함.
//	              return true;
//	          }
	        }
	    },
	    {
	        dataField : "ownerYn",
	        headerText : "Owner Yn",
	        editable : false,
	        renderer : {
	            type : "CheckBoxEditRenderer",
	            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
	            checkValue : "Y", // true, false 인 경우가 기본
	            unCheckValue : "N"
	        },
	        visible : false
	    },
	    {
	        dataField : "existYn",
	        headerText : "Exist Yn",
	        editable : false,
	        renderer : {
	            type : "CheckBoxEditRenderer",
	            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
	            checkValue : "Y", // true, false 인 경우가 기본
	            unCheckValue : "N"
	        },
	        visible : false
	    },
	    {
	        dataField : "baseYn",
	        headerText : "Baseauth Yn",
	        editable : false,
	        renderer : {
	            type : "CheckBoxEditRenderer",
	            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
	            checkValue : "Y", // true, false 인 경우가 기본
	            unCheckValue : "N"
	        },
	        visible : false
	    }

	];

var detailOptions =
{
        editable : true,
        usePaging : true, //페이징 사용
        useGroupingPanel : false, //그룹핑 숨김
        showRowNumColumn : false, // 순번 칼럼 숨김
        applyRestPercentWidth  : false,
        rowIdField : "rowId", // PK행 지정
        selectionMode : "multipleRows",
        editBeginMode : "click", // 편집모드 클릭
        /* aui 그리드 체크박스 옵션*/
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제

};

$(document).ready(function(){

	$("#rbt").attr("style","display:none");
	grdOriAuth = GridCommon.createAUIGrid("res_grid_wrap", gridAuthColumnLayout,"", options);
	grdReqAuth = GridCommon.createAUIGrid("req_grid_wrap", gridReqAuthColumnLayout ,"", reqOptions);
	grdReqMenuMapping = GridCommon.createAUIGrid("req_menu_grid_wrap", gridMenuMappingColumnLayout,"", detailOptions);
      /* var item = { "areaId" :  "xx-xxxx", "area" : "", "postcode" :  "", "city" :  "", "state" :  "", "country" :  "", "countrycode" :  "", "statusId" :  "Active", "id" :  "Internal"}; //row 추가

      myGridID4 = GridCommon.createAUIGrid("grid_wrap4", columnLayout4,null,"");

      AUIGrid.addRow(myGridID4, item, "last"); //row 추가

      //아이템 grid 행 추가
      $("#addRow_other").click(function() {

          AUIGrid.addRow(myGridID4, item, "last");

      });

      //save
      $("#save_other").click(function() {

    	  // 버튼 클릭시 cellEditCancel  이벤트 발생 제거. => 편집모드(editable=true)인 경우 해당 input 의 값을 강제적으로 편집 완료로 변경.
    	  AUIGrid.forceEditingComplete(myGridID4, null, false);

          if (validation_other()) {
              Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridData_other);
           }
      });  */

      AUIGrid.bind(grdReqAuth, "removeRow", function( event ) {
    	  console.log("removeRow");
    	  console.log(AUIGrid.getGridData(grdReqAuth));
    	  fn_searchDetails();
      });
}); //Ready

function fn_doConfirm() {
	Common.ajax(
            "GET",
            "/common/selectAuthList.do",
            "authCode="+$("#newAuthCode").val(),
            function(data, textStatus, jqXHR){ // Success
                if(data.length == 1){
                    $("#newAuthName").val(data[0].authName);
                }else{
                	Common.alert("Auth Code not exist");
                }

            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            }
    )
}

function fn_doOldAuthSearch() {
	var val = {"authCode" : $('#oldAuthCode').val(),"authName" : $('#oldAuthName').val()};
    Common.ajax(
        "GET",
        "/common/selectAuthList.do",
        val,
        function(data, textStatus, jqXHR){ // Success
            AUIGrid.setGridData(grdOriAuth, data);
        },
        function(jqXHR, textStatus, errorThrown){ // Error
            alert("Fail : " + jqXHR.responseJSON.message);
        }
    )
};

$(function(){
	$("#rightbtn").click(function() {
        checkedItems = AUIGrid.getCheckedRowItemsAll(grdOriAuth);

        var reqitms = AUIGrid.getGridData(grdReqAuth);
        /* var maxItem = 40;

        if (reqitms.length + checkedItems.length > maxItem){
            Common.alert("Maximum " + maxItem + " Material Code per SMO request.");
            return false;
        } */

        var bool = true;
        if (checkedItems.length > 0) {
            var rowPos = "first";
            var item = new Object();
            var rowList = [];

            var boolitem = true;
            var k = 0;
            for (var i = 0; i < checkedItems.length; i++) {

                for (var j = 0; j < reqitms.length; j++) {

                    if (reqitms[j].authCode == checkedItems[i].authCode) {
                        boolitem = false;
                        break;
                    }
                }

                if (boolitem) {
                    rowList[k] = {
                        authCode : checkedItems[i].authCode,
                        authName : checkedItems[i].authName
                    }
                    k++;
                }

                AUIGrid.addUncheckedRowsByIds(grdReqAuth, checkedItems[i].rowId);
                boolitem = true;
            }

            AUIGrid.addRow(grdReqAuth, rowList, rowPos);

            fn_searchDetails();
        }
    });

	$('#reqdel').click(function() {
		checkedItems = AUIGrid.getCheckedRowItemsAll(grdReqAuth);
		if (checkedItems.length > 0) {
			for (var i = 0; i < checkedItems.length; i++) {
				AUIGrid.removeRow(grdReqAuth, AUIGrid.getRowIndexesByValue(grdReqAuth, "authCode", checkedItems[i].authCode));
		        //AUIGrid.removeRow(grdReqAuth, "selectedIndex");
		        //AUIGrid.removeSoftRows(grdReqAuth);
			}
		}
        //fn_searchDetails();
    });

});

function fn_searchDetails(){
    console.log("fn_searchDetails");
    var authList = [];
    var k = 0;
    var data = {gridData:AUIGrid.getGridData(grdReqAuth)};
    var obj = $("#sForm").serializeJSON();
    var checkedItems = AUIGrid.getGridData(grdReqAuth);
    obj.gridData = checkedItems;
    if (checkedItems.length > 0) {

    	for (var i = 0; i < checkedItems.length; i++) {
    		authList.push(checkedItems[i].authCode);
    		/* if(authList == ""){
    			authList += "'" + checkedItems[i].authCode + "'"
    		}else{
    			authList += ",'" + checkedItems[i].authCode + "'"
    		} */
    	}
    }
    Common.ajaxSync(
            "POST",
            "/common/selectMultAuthMenuMappingList.do",
            data,
            function(result){
                AUIGrid.setGridData(grdReqMenuMapping, result);
            });
}

function fn_saveNewAuthAccess(){

    var gridList= AUIGrid.getGridData(grdReqMenuMapping);
    var obj = $("#sForm").serializeJSON();
    obj.gridList = gridList;
    console.log(gridList);
    Common.confirm("<spring:message code='sys.common.alert.save'/>",function(){
        Common.ajax(
                "POST",
                "/common/saveMultAuthMenuMappingList.do",
                obj,
                function(data, textStatus, jqXHR){ // Success
                    Common.alert("<spring:message code='sys.msg.success'/>");
                    $("#_authAccessPop").remove();
                },
                function(jqXHR, textStatus, errorThrown){ // Error
                    alert("Fail : " + jqXHR.responseJSON.message);
                }
        )
    });
};
/* function fn_saveGridData_other(){
    Common.ajax("POST", "/common/saveOtherAddressMaster.do", GridCommon.getEditData(myGridID4), function(result) {
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
        $("#search").trigger("click");
        Common.alert("<spring:message code='sys.msg.success'/>");
    }, function(jqXHR, textStatus, errorThrown) {
        try {
            console.log("status : " + jqXHR.status);
            console.log("code : " + jqXHR.responseJSON.code);
            console.log("message : " + jqXHR.responseJSON.message);
            console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
        } catch (e) {
            console.log(e);
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
}

function validation_other() {
    var result = true;
    var addList = AUIGrid.getAddedRowItems(myGridID4);

    if (addList.length == 0) {
      Common.alert("<spring:message code='sys.common.alert.noChange'/>");
      return false;
    }

    if(!validationCom_other(addList)){
        return false;
   }

    return result;
}


function validationCom_other(list){
    var result = true;

    //var lengthPostcode = postcode.length;

    for (var i = 0; i < list.length; i++) {
           var area = list[i].area;
           var postcode = list[i].postcode;
           var city = list[i].city;
           var state = list[i].state;
           var country = list[i].country;
           var countrycode = list[i].countrycode;

           var lengthPostcode = postcode.length;
           var lengthCountrycode = countrycode.length;

           if (area == "") {
        	   result = false;
        	   Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ oArea +"' htmlEscape='false'/>");
        	   break;
           } else if(postcode == ""){
        	   result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ oPostcode +"' htmlEscape='false'/>");
               break;
           } else if(city == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ oCity +"' htmlEscape='false'/>");
               break;
           } else if(state == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ oState +"' htmlEscape='false'/>");
               break;
           } else if(country == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ oCountry +"' htmlEscape='false'/>");
               break;
           } else if(countrycode == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ oCountrycode +"' htmlEscape='false'/>");
               break;
           } else if(lengthPostcode > 15){
        	   result = false;
        	   //Common.alert("<spring:message code='sys.msg.limitCharacter' arguments='" + oPostcode +" ; 5' htmlEscape='false' argumentSeparator=';' />");
               Common.alert("Postcode can not exceed 15 digits.");
               break;
           } else if(lengthCountrycode != 2){
               result = false;
               Common.alert("<spring:message code='sys.msg.limitCharacter' arguments='" + oCountrycode +" ; 2' htmlEscape='false' argumentSeparator=';' />");
               break;
           }
    }

    return result;
}

function removeRowDetail_other()
{
    AUIGrid.removeRow(myGridID4, "selectedIndex");
}
 */
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Access Replication</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<section id="content"><!-- content start -->

<section class="search_table"><!-- search_table start -->
<form action="#"   id="sForm"  name="sForm" method="post" >
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Auth Code</th>
    <td>
           <input type="text" title="" id="newAuthCode" name="newAuthCode" placeholder="Auth Code" class="" />
           <p class="btn_sky"  id='cbt'> <a href="#" onclick="javascript: fn_doConfirm()"> <spring:message code="sal.btn.confirm" /></a></p>
           <!-- <input type="text" title="" id="ORD_NO_RESULT" name="ORD_NO_RESULT"   placeholder="" class="readonly " readonly="readonly" /> -->
           <p class="btn_sky" id="rbt"> <a href="#" onclick="javascript :fn_doReset()"><spring:message code="sal.btn.reselect" /></a></p>
    </td>
</tr>
<tr>
    <th scope="row">Auth Name</th>
    <td>
           <input type="text" title="" id="newAuthName" name="newAuthName" placeholder="" class="w100p readonly " readonly="readonly"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Information</h3>
</aside><!-- title_line end -->

<section class="search_result"><!-- search_result start -->

<form action="#"   id="sOldForm"  name="sOldForm" method="post" >
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:50px" />
    <col style="width:80px" />
    <col style="width:50px" />
    <col style="width:110px" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Auth Code</th>
    <td>
           <input type="text" title="" id="oldAuthCode" name="oldAuthCode" placeholder="" class="w40p" />
    </td>
    <th scope="row">Auth Name</th>
    <td>
           <input type="text" title="" id="oldAuthName" name="oldAuthName" placeholder="" class="w40p"/>
           <p class="btn_sky"  id='oldAuthSearch'> <a href="#" onclick="javascript: fn_doOldAuthSearch()"> Search</a></p>
    </td>

</tr>
</tbody>
</table><!-- table end -->
</form>

<div class="divine_auto"><!-- divine_auto start -->

<div class="border_box" style="width:40%; height:450px;padding-top: 18px;"><!-- border_box start -->

<div class="divine_auto type2">
            <!-- divine_auto start -->

            <div style="width: 50%">
                <!-- 50% start -->

                <aside class="title_line">
                    <!-- title_line start -->
                    <h3>Auth Details</h3>
                </aside>
                <!-- title_line end -->

                <div class="border_box" style="height: 340px;">
                    <!-- border_box start -->

                    <article class="grid_wrap">
                        <!-- grid_wrap start -->
                        <div id="res_grid_wrap"></div>
                    </article>
                    <!-- grid_wrap end -->

                </div>
                <!-- border_box end -->

            </div>
            <!-- 50% end -->

            <div style="width: 50%">
                <!-- 50% start -->

                <aside class="title_line">
                    <!-- title_line start -->
                    <h3>Request Auth</h3>
                    <ul class="right_btns">
                        <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
                        <!--     <li><p class="btn_grid"><a id="reqadd">ADD</a></p></li> -->
                        <li><p class="btn_grid">
                                <a id="reqdel">DELETE</a>
                            </p></li>
                        <%-- </c:if> --%>
                    </ul>
                </aside>
                <!-- title_line end -->

                <div class="border_box" style="height: 340px;">
                    <!-- border_box start -->

                    <article class="grid_wrap">
                        <!-- grid_wrap start -->
                        <div id="req_grid_wrap"></div>
                    </article>
                    <!-- grid_wrap end -->

                    <ul class="btns">
                        <li><a id="rightbtn"><img
                                src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif"
                                alt="right" /></a></li>
                        <%--     <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left2.gif" alt="left" /></a></li> --%>
                    </ul>

                </div>
                <!-- border_box end -->

            </div>
            <!-- 50% end -->

        </div>
        <!-- divine_auto end -->

</div><!-- border_box end -->

</div><!-- divine_auto end -->



<div class="border_box" style="height:150px;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Menu</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="req_menu_grid_wrap" class="autoGridHeight"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
                        <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
                        <!--     <li><p class="btn_grid"><a id="reqadd">ADD</a></p></li> -->
                        <li><p class="btn_blue2">
                                <a href="#" onclick="fn_saveNewAuthAccess();"><spring:message code='sys.btn.save'/></a>
                            </p></li>
                        <%-- </c:if> --%>
                    </ul>

</div><!-- border_box end -->



</section><!-- search_result end -->


<%-- <ul class="left_btns">
    <li><p class="btn_grid"><a href="#" id="addRow_other"><spring:message code='sys.btn.add'/></a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="removeRowDetail_other();"><spring:message code='sys.btn.del'/></a></p></li>
</ul> --%>

<%-- <article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap4" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="save_other"><spring:message code='sys.btn.save'/></a></p></li>
</ul> --%>

</section>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->