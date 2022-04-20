<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">


$(document).ready(function() {

    var listMyGridID;

    createAUIGrid();

   if("${memType}"== "1"){

       if("${SESSION_INFO.memberLevel}" =="1"){
          $("#orgCode_actHP").attr("class", "w100p readonly");
          $("#orgCode_actHP").attr("readonly", "readonly");

      }else if("${SESSION_INFO.memberLevel}" =="2"){
          $("#orgCode_actHP").attr("class", "w100p readonly");
          $("#orgCode_actHP").attr("readonly", "readonly");
          $("#grpCode_actHP").attr("class", "w100p readonly");
          $("#grpCode_actHP").attr("readonly", "readonly");

      }else if("${SESSION_INFO.memberLevel}" =="3"){
          $("#orgCode_actHP").attr("class", "w100p readonly");
          $("#orgCode_actHP").attr("readonly", "readonly");

          $("#grpCode_actHP").attr("class", "w100p readonly");
          $("#grpCode_actHP").attr("readonly", "readonly");

          $("#deptCode_actHP").attr("class", "w100p readonly");
          $("#deptCode_actHP").attr("readonly", "readonly");
      }

       fn_selectSmfActHpListAjax();
  }

});



$(function(){
    $('#btnSrch_actHP').click(function() {
    	fn_selectSmfActHpListAjax();
    });

     $("#download_actHP").click(function() {
          GridCommon.exportTo("list_grid_wrap_actHP", 'xlsx', "Performance View actHP List");
      });

});

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password'  || tag === 'textarea'){
            if($("#"+this.id).hasClass("readonly")){

            }else{
                this.value = '';
            }
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;

        }else if (tag === 'select'){
            if($("#memType").val() != "7"){ //check not HT level
                 this.selectedIndex = 0;
            }
        }

    });
};


function createAUIGrid() {

    //AUIGrid 칼럼 설정
    var columnLayout = [

        { headerText : "Code",   dataField : "memCode",       editable : false, width : 100 }
      , { headerText : "HP Name",    dataField : "fullName", editable : false, width : 150 }
      , { headerText : "Org Code", dataField : "orgCode",       editable : false, width : 80  }
      , { headerText : "Grp Code",  dataField : "grpCode", editable : false, width : 80  }
      , { headerText : "Dept Code", dataField : "deptCode", editable : false, width : 80  }
      , { headerText : "Month",   dataField : "month",      editable : false, width : 100 }
      , { headerText : "Newly Recruit",   dataField : "recruit",      editable : false, width : 100 }
      , { headerText : "Week 1", dataField : "keyinW1",   editable : false, width : 100 }
      , { headerText : "Week 2", dataField : "keyinW2",   editable : false, width : 100 }
      , { headerText : "Week 3", dataField : "keyinW3",   editable : false, width : 100 }
      , { headerText : "Week 4", dataField : "keyinW4",   editable : false, width : 100 }
      , { headerText : "Total Key",  dataField : "keyinTotalAmt", editable : false, width : 60  }
      , { headerText : "Net",   dataField : "netsalesTotalAmt", editable : false, width : 60  }];

    //그리드 속성 설정
    var gridPros = {
        usePaging           : true,         //페이징 사용
        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
        editable            : false,
        fixedColumnCount    : 1,
        showStateColumn     : false,
        displayTreeOpen     : false,
      //selectionMode       : "singleRow",  //"multipleCells",
        headerHeight        : 30,
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
        noDataMessage       : "No record found.",
        groupingMessage     : "Here groupping"
    };

    listMyGridID = GridCommon.createAUIGrid("list_grid_wrap_actHP", columnLayout, "", gridPros);

    if("${memType}"== "1"){
    	console.log("fffff");
    	fn_selectSmfActHpListAjax();
    }

}

function fn_selectSmfActHpListAjax() {
        Common.ajax("GET", "/organization/selectSmfActHp.do", $("#form_actHP").serialize(), function(result) {
            AUIGrid.setGridData(listMyGridID, result);
        });

    }


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Active HP</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
</aside><!-- title_line end -->

<ul class="right_btns">
  <li><p class="btn_blue"><a id="btnSrch_actHP" href="#"><span class="search"></span><spring:message code='sales.Search'/></a></p></li>
    <li><p class="btn_blue"><a id="btnClear_actHP" href="#" onclick="javascript:$('#form_actHP').clearForm();"><span class="clear"></span><spring:message code='sales.Clear'/></a></p></li>
</ul>

<section class="search_table mt10"><!-- search_table start -->
<form action="#" method="post" id="form_actHP" name="form_actHP">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />

</colgroup>
<tbody>
<tr>
    <th scope="row">Org Code</th>
    <td><input id="orgCode_actHP" name="orgCode_actHP" type="text" title="orgCode_actHP"  class="w100p" value = '${orgCode}'.trim() /></td>

    <th scope="row">Grp Code</th>
    <td><input id="grpCode_actHP" name="grpCode_actHP" type="text" title="grpCode_actHP"  class="w100p" value = '${grpCode}'.trim()/></td>

    <th scope="row">Dept Code</th>
    <td><input id="deptCode_actHP" name="deptCode_actHP" type="text" title="deptCode_actHP"  class="w100p" value = '${deptCode}'.trim()/></td>
</tr>

<tr>
    <th scope="row">Month</th>
    <td><input type="text" title="기준년월" id="netSalesMonth_actHP" name="netSalesMonth_actHP" placeholder="MM/YYYY" class="j_date2 w100p" /></td>

	<th></th>
	<td></td>

	<th></th>
	<td></td>
</tr>

</tbody>
</table><!-- table end -->
</form>


<section class="search_result"><!-- search_result start -->
<article class="grid_wrap"><!-- grid_wrap start -->
   <ul class="right_btns">
   <li><p class="btn_grid"><a id="download_actHP">GENERATE</a></p></li>
   </ul>
    <div id="list_grid_wrap_actHP" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->