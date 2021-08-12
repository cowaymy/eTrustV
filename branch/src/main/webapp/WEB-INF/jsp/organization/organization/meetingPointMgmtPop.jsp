<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
console.log("meetingPointMgmtPop");

var myGridID;

$(document).ready(function() {
    createAUIGrid();
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label>");
});

function createAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [
        {
            dataField : "meetPointId",
            headerText : "Meeting Point ID",
            dataType : "numeric",
            width : 150,
            editable : false
        }, {
            dataField : "meetPointCode",
            headerText : "Meeting Point Code",
            width : 150,
            editable : true
        }, {
            dataField : "meetPointDesc",
            headerText : "Meeting Point Description",
            width : 500,
            editable : true
        }, {
            dataField : "stus",
            headerText : "Status",
            renderer : {
                type : "CheckBoxEditRenderer",
                showLabel : false,
                editable : true,
                checkValue : "ACTIVE",
                unCheckValue : "INACTIVE"
            }
        }
    ];
     // 그리드 속성 설정
    var gridPros = {
        usePaging : true,
        pageRowCount : 20,
        editable : true,
        showStateColumn : true,
        displayTreeOpen : true,
        headerHeight : 30,
        skipReadonlyColumns : true,
        wrapSelectionMove : true,
        showRowNumColumn : false,
    };

    myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
}

function fn_searchMP() {
    Common.ajax("GET", "/organization/searchMP", $("#meetingPointForm").serialize(), function(result) {
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_addRow() {
    var newSeq;
    var gridCnt = AUIGrid.getRowCount(myGridID);
    var idList;

    Common.ajax("GET", "/organization/getNextMPSeq", "", function(result) {
        console.log(result.data);

        if(gridCnt >= 1) {
            idList = AUIGrid.getColumnValues(myGridID, "meetPointId", true);

            if(idList[0] > idList[gridCnt - 1]) {
                newSeq = idList[0] + 1;
            } else {
                newSeq = idList[gridCnt - 1] + 1;
            }
        } else {
            newSeq = result.data;
        }

        if(newSeq < result.nextSeq) {
            AUIGrid.addRow(myGridID, {meetPointId : result.data, meetPointCode : "", meetPointDesc : "", stus : "0"}, "first");
        } else {
            AUIGrid.addRow(myGridID, {meetPointId : newSeq, meetPointCode : "", meetPointDesc : "", stus : "0"}, "first");
        }
    });
}

function checkGrid() {
    var addedItems = AUIGrid.getAddedRowItems(myGridID);
    var editedItems = AUIGrid.getEditedRowColumnItems(myGridID);

    if(addedItems.length <= 0 && editedItems.length <= 0) {
        return false;
    }

    return true;
}

function fn_saveGrid() {
    if(checkGrid()) {
        Common.ajax("POST", "/organization/saveMeetingPointGrid", GridCommon.getEditData(myGridID), function(result) {
            console.log(result);

            if(result.code == "00") {
                Common.alert("Save success.", fn_searchMP());
            } else {
                Common.alert("Save failure.");
            }
        });
    }
}

function fn_gridToExcel(){
    GridCommon.exportTo("grid_wrap", "xlsx", "Meeting Point List");
}

function fn_uploadMPUpdate() {
    //updateHPMeetingPoint
    var formData = new FormData();
    formData.append("csvFile", $("input[name=fileSelector]")[0].files[0]);

    Common.ajaxFile("/organization/updateHPMeetingPoint", formData, function(result) {
       console.log("updateHPMeetingPoint");
       console.log(result);

       if(result.code == "00") {
           Common.alert("Metting point update complete.");
       } else {
           Common.alert("Metting point update failed.");
       }
    });
}
</script>

<!-- popup_wrap start -->
<div id="popup_wrap" class="popup_wrap">
    <!-- pop_header start -->
    <header class="pop_header">
        <h1>Meeting Point Management</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <section class="pop_body">
        <aside class="title_line">
	        <ul class="right_btns">
	            <li>
	               <p class="btn_blue"><a href="#" onclick="javascript : fn_searchMP()"><span class="search"></span>Search</a></p>
	            </li>
	        </ul>
        </aside>

        <form id="meetingPointForm" action="#" method="GET">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:170px" />
                    <col style="width:*" />
                    <col style="width:170px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Meeting Point Code</th>
                        <td>
                            <input id="mpCode" type="text" name="mpCode" title="" placeholder="Meeting Point Code" class="w100p" maxlength="15" />
                        </td>
                        <th scope="row">Meeting Point Name</th>
                        <td>
                            <input id="mpName" type="text" name="mpName" title="" placeholder="Meeting Point Name" class="w100p" />
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->

            <aside class="title_line">
                <ul class="right_btns">
	                <li>
	                   <p class="btn_grid"><a href="#" onclick="javascript : fn_addRow()">Add Row</a></p>
	                </li>
	                <li>
                       <p class="btn_grid"><a href="#" onclick="javascript : fn_saveGrid()">Save Data</a></p>
                    </li>
                    <li>
                       <p class="btn_grid"><a href="#" onclick="javascript : fn_gridToExcel()">Generate Excel</a></p>
                    </li>
	            </ul>
            </aside>

            <!-- Grip Wrap Start -->
            <article class="grid_wrap" id="grid_wrap">
            </article>
            <!-- Grip Wrap End -->

            <article>
                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width: 170px" />
                        <col style="width: *" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Update File</th>
                            <td>
                                <!-- auto_file start -->
                                <div class="auto_file2 attachment_file w100p" id="mpFileSelector">
                                    <input type="file" id="fileSelector" name="fileSelector" title="file add" accept=".csv" />
                                </div>
                                <!-- auto_file end -->
                            </td>
                        </tr>
                    </tbody>
                </table>

                <ul class="center_btns">
                    <li><p class="btn_blue2"><a href="${pageContext.request.contextPath}/resources/download/organization/HP_MeetingPoint_Update.csv">Download Template</a></li>
                    <li><p class="btn_blue2"><a href="#" onclick="javascript : fn_uploadMPUpdate()">Upload</a></li>
                </ul>
            </article>
        </form>
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
