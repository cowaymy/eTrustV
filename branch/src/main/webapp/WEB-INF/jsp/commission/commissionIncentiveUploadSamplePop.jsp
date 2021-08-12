<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.my-left-column {
    text-align:left;
}
</style>
<script type="text/javaScript">
var hpGridID;
var cdGridID;

    $(document).ready(function() {
    	createAUIGridHp();
    	createAUIGridCd();
    	
    	Common.ajax("GET","/commission/calculation/incntivSampleHpList","", function(result) {
            //console.log("성공.");
            console.log("data : " + result);
            AUIGrid.setGridData(hpGridID, result);
        });
    	
    	Common.ajax("GET","/commission/calculation/incntivSampleCdList","", function(result) {
            //console.log("성공.");
            console.log("data : " + result);
            AUIGrid.setGridData(cdGridID, result);
        });
    	
    });
    
    function createAUIGridHp() {
        var columnLayout = [ {
            dataField : "code",
            headerText : "Code",
            style : "my-column",
            width : 60,
            editable : false
        },{
            dataField : "codeName",
            headerText : "Name",
            style : "my-left-column",
            editable : false
        }];
        // 그리드 속성 설정
        var gridPros = {
            
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : false,
            selectionMode : "singleRow"
        };
        
        hpGridID = AUIGrid.create("#grid_wrap_hp", columnLayout,gridPros);
   }
    
    function createAUIGridCd() {
        var columnLayout = [ {
            dataField : "code",
            headerText : "Code",
            style : "my-column",
            width : 60,
            editable : false
        },{
            dataField : "codeName",
            headerText : "Name",
            style : "my-left-column",
            editable : false
        }];
        // 그리드 속성 설정
        var gridPros = {
            
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : false,
            selectionMode : "singleRow",
        };
        
        cdGridID = AUIGrid.create("#grid_wrap_cd", columnLayout,gridPros);
   }
</script>

<div id="popup_wrap2" class="popup_wrap size_big"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code='commission.title.pop.head.incentiveSample'/></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<div class="divine_auto"><!-- divine_auto start -->

	<div style="width:50%">
		<aside class="title_line"><!-- title_line start -->
		<h2><spring:message code='commission.text.type.healthPlanner'/></h2>
		</aside><!-- title_line end -->
		<article class="grid_wrap"><!-- grid_wrap start -->
		  <div id="grid_wrap_hp" style="width: 100%; height: 334px; margin: 0 auto;"></div>
		</article><!-- grid_wrap end -->
	</div>

	<div style="width:50%">
		<aside class="title_line"><!-- title_line start -->
		<h2><spring:message code='commission.text.type.cowayLady'/></h2>
		</aside><!-- title_line end -->
		<article class="grid_wrap"><!-- grid_wrap start -->
		  <div id="grid_wrap_cd" style="width: 100%; height: 334px; margin: 0 auto;"></div>
		</article><!-- grid_wrap end -->
	</div>

</div><!-- divine_auto end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->