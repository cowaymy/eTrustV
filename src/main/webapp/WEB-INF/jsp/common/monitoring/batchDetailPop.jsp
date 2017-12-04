<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<style type="text/css">
    /* 커스텀 칼럼 스타일 정의 */
    .aui-grid-user-custom-left {
        text-align: left;
    }

    #textAreaWrap {
        font-size: 12px;
        position: absolute;
        height: 100px;
        min-width: 100px;
        background: #fff;
        border: 1px solid #555;
        display: none;
        padding: 4px;
        text-align: right;
        z-index: 9999;
    }
</style>

<script type="text/javaScript">
    var detailGridId;
    var detailColumnLayout =
        [
            {
                dataField: "stepExecutionId",
                headerText: "STEP_EXECUTION_ID",
                width: "8%",
                editable: false,
                visible: false
            },
            {
                dataField: "seq",
                headerText: "SEQ",
                width: "5%",
                editable: false,
                visible: false
            },
            {
                dataField: "jobProcName",
                headerText: "JOB_PROC_NAME",
                style: "aui-grid-user-custom-left ",
                editable: false,
                width: "10%"
            },
            {
                dataField: "stepProcName",
                headerText: "STEP_PROC_NAME",
                editable: false,
                width: "10%"
            },
            {
                dataField: "procedureName",
                headerText: "PROCEDURE_NAME",
                style: "aui-grid-user-custom-left ",
                editable: false,
                width: "10%"
            },
            {
                dataField: "msg",
                headerText: " MSG",
                style: "aui-grid-user-custom-left ",
                editable: false
            },
            {
                dataField: "crtUserId",
                headerText: "CRT_USER_ID",
                style: "aui-grid-user-custom-left ",
                editable: false,
                width: "10%"
            },
            {
                dataField: "crtDt",
                headerText: "CRT_DT",
                editable: false,
                width: "10%"
            }
        ];

    $(document).ready(function () {
        // 워드랩 적용
        var auiGridProps = {
            wordWrap: true
        };
        detailGridId = GridCommon.createAUIGrid("detailGridId", detailColumnLayout, null, auiGridProps);
        fn_getBatchDetailList($("#stepExecutionId").val());
    });

    // Tag Status 리스트 조회.
    function fn_getBatchDetailList(stepExecutionId) {
        Common.ajax("GET", "/common/monitoring/getBatchDetailList.do", {stepExecutionId: stepExecutionId}, function (result) {
            AUIGrid.setGridData(detailGridId, result);
        });
    }

</script>
<div id="popup_wrap" class="popup_wrap size_middle"><!-- popup_wrap start -->

    <input type="hidden" id="stepExecutionId" name="stepExecutionId" value="${stepExecutionId}">

    <header class="pop_header"><!-- pop_header start -->
        <h1>Tag Status</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <article class="grid_wrap"><!-- grid_wrap start -->
            <!-- 그리드 영역2 -->
            <div id="detailGridId" style="height:400px;"></div>
        </article><!-- grid_wrap end -->
    </section><!-- pop_body end -->
</div>
<!-- popup_wrap end -->