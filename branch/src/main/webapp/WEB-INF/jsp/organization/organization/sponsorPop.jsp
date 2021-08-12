<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">
var myGridID3;
var grpOrgList = new Array(); // Group Organization List
var orgList = new Array(); // Organization List

//Start AUIGrid
$(document).ready(function() {

    // AUIGrid 그리드를 생성합니다.
    createAUIGrid3();


    // To show Type of Leave selection
    doGetCombo('/organization/selectMemberType.do','' ,'','cmbMemberType' ,'S','');
    doGetCombo('/organization/selectSponBrnchList.do','' ,'','cmbBranch' ,'S','');

    var tempsponsorCd = $("#sponsorCd").val();

    if(tempsponsorCd != ""){
        $("#txtMemberCode").val(tempsponsorCd);

        fn_sponMemberSearch();
    }

     // 셀 더블클릭 이벤트 바인딩
     AUIGrid.bind(myGridID3, "cellDoubleClick", function(event) {
       var msponsorCd = AUIGrid.getCellValue(myGridID3, event.rowIndex, "memCode");
       var msponsorNm =  AUIGrid.getCellValue(myGridID3, event.rowIndex, "name");
       var msponsorNric =  AUIGrid.getCellValue(myGridID3, event.rowIndex, "nric");

       fn_addSponsor(msponsorCd, msponsorNm, msponsorNric);

     });

});



function createAUIGrid3() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "memId",
        headerText : "Member ID",
        editable : false,
        width : 120
    }, {
        dataField : "memType",
        headerText : "Member Type",
        editable : false,
        width : 130,
        visible:false
    }, {
        dataField : "memCode",
        headerText : "Member Code",
        editable : false,
        width : 130
    }, {
        dataField : "codeName",
        headerText : "codeName",
        editable : false,
        width : 130,
        visible:false
    }, {
        dataField : "name",
        headerText : "Member Name",
        editable : false,
        width : 180
    }, {
        dataField : "nric",
        headerText : "Member IC",
        editable : false,
        width : 180
    }, {
        dataField : "name1",
        headerText : "updator",
        editable : false,
        width : 180,
        visible:false
    }, {
        dataField : "name1",
        headerText : "updator",
        editable : false,
        width : 180,
        visible:false
    }, {
        dataField : "stus",
        headerText : "updator",
        editable : false,
        width : 180,
        visible:false
    }, {
        dataField : "c1",
        headerText : "updator",
        editable : false,
        width : 180 ,
        visible:false
    }];
     // 그리드 속성 설정
    var gridPros = {

        // 페이징 사용
        usePaging : true,

        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,

        editable : true,

        showStateColumn : true,

        displayTreeOpen : true,


        headerHeight : 30,

        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,

        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,

        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : true

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID3 = AUIGrid.create("#grid_wrap3", columnLayout, gridPros);
}







function fn_sponMemberSearch(){

    var jsonObj = {
            cmbMemberType: $("#cmbMemberType").val(),
            txtMemberCode: $("#txtMemberCode").val(),
            txtMemberName: $("#txtMemberName").val(),
            txtICNumber: $("#txtICNumber").val(),
            cmbBranch: $("#cmbBranch").val(),
            cmbBranch: $("#cmbBranch").val(),
            deptCd: $("#txtDept") .val()
          };

    Common.ajax("GET", "/organization/sponMemberSearch.do", jsonObj, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID3, result);
    });

}





function fn_winClose(){

    this.close();
}
</script>


<!-- --------------------------------------DESIGN ----------------------------------- -->

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>::Coway:: We Bring Wellness - Search Member</h1>
<ul class="right_opt">
    <li><p class="btn_blue"><a href="javascript:fn_sponMemberSearch();"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" id="membeSponForm" method="post">

 <input type="hidden" id="txtDept" name="txtDept" value="${deptCd}"/>
 <input type="hidden" value="<c:out value="${codeValue}"/>" id="codeValue"/>
 <input type="hidden" value="<c:out value="${memberView.memId}"/>" id="memberid"/>
 <input type="hidden" value="<c:out value="${memberView.memType}"/> "  id="memtype"/>
 <input type="hidden" value="<c:out value="${memberView.bank}"/> "  id="bank"/>
 <input type="hidden" value="<c:out value="${memberView.hsptlz}"/> "  id="hsptlz"/>
<section class="tap_wrap"><!-- tap_wrap start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>
     <select class="w100p" id="cmbMemberType" name="cmbMemberType">    </select>
    </td>
    <th scope="row">Member Code</th>
    <td>
    <input type="text" title=""  class="w100p" id="txtMemberCode" name="txtMemberCode"/>
    </td>
</tr>
<tr>
    <th scope="row">Member Name</th>
    <td>
    <input type="text" title=""  class="w100p" id="txtMemberName" name="txtMemberName"/>
    </td>
    <th scope="row">IC Number</th>
    <td>
    <input type="text" title=""  class="w100p" id="txtICNumber" name="txtICNumber"/>
    </td>

</tr>
<tr>
    <th scope="row">Branch</th>
    <td>
        <select class="w100p" id="cmbBranch" name="cmbBranch">    </select>
    </td>
</tr>

</tbody>
</table>



<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="grid_wrap3" style="width: 100%; height: 530px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->



</form>
<!--  ---------------------------------------------------------------------------  -->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

