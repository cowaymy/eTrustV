<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var listGrid;
var subGrid;
var mdcGrid;

var rescolumnLayout=[{dataField:"rnum"         ,headerText:"RowNum"                      ,width:120    ,height:30 , visible:false},
                     {dataField:"status"       ,headerText:"Status"                      ,width:120    ,height:30 , visible:false},
                     {dataField:"reqstno"      ,headerText:"STO"        ,width:120    ,height:30                },
                     {dataField:"staname"      ,headerText:"Status"                      ,width:120    ,height:30                },
                     {dataField:"reqloc"       ,headerText:"From Location"               ,width:120    ,height:30 , visible:false},
                     {dataField:"reqlocnm"     ,headerText:"From Location"               ,width:120    ,height:30 , visible:false},
                     {dataField:"rcvlocdesc"   ,headerText:"From Location"               ,width:120    ,height:30                },
                     {dataField:"rcvloc"       ,headerText:"To Location"                 ,width:120    ,height:30 , visible:false},
                     {dataField:"rcvlocnm"     ,headerText:"To Location"                 ,width:120    ,height:30 , visible:false},
                     {dataField:"reqlocdesc"   ,headerText:"To Location"                 ,width:120    ,height:30                },
                     {dataField:"itmcd"        ,headerText:"Material Code"               ,width:120    ,height:30 , visible:true },
                     {dataField:"itmname"      ,headerText:"Material Name"               ,width:120    ,height:30                },
                     {dataField:"reqstqty"     ,headerText:"Requested Qty"               ,width:120    ,height:30                },
                     {dataField:"delvno"       ,headerText:"delvno"                      ,width:120    ,height:30 , visible:false},
                     {dataField:"delyqty"      ,headerText:"Delivered Qty"               ,width:120    ,height:30 },
                     {dataField:"rciptqty"     ,headerText:"Good Issued Qty"             ,width:120    ,height:30 },
                     {dataField:"rciptqty"     ,headerText:"Good Receipted Qty"          ,width:120    ,height:30                },
                     {dataField:"docno"        ,headerText:"Ref Doc.No"          ,width:120    ,height:30                },
                     {dataField:"uom"          ,headerText:"Unit of Measure"             ,width:120    ,height:30 , visible:false},
                     {dataField:"uomnm"        ,headerText:"Unit of Measure"             ,width:120    ,height:30                },
                     {dataField:"reqitmno"     ,headerText:"STO Item"                    ,width:120    ,height:30 , visible:false},
                     {dataField:"ttype"        ,headerText:"Transaction Type"            ,width:120    ,height:30 , visible:false},
                     {dataField:"ttext"        ,headerText:"Transaction Type"       ,width:120    ,height:30                },
                     {dataField:"mtype"        ,headerText:"Movement Type"               ,width:120    ,height:30 , visible:false},
                     {dataField:"mtext"        ,headerText:"Movement Type"               ,width:120    ,height:30                },
                     {dataField:"froncy"       ,headerText:"Auto / Manual"               ,width:120    ,height:30                },
                     {dataField:"crtdt"        ,headerText:"Request Create Date"         ,width:120    ,height:30                },
                     {dataField:"reqdate"      ,headerText:"Request Required Date"       ,width:120    ,height:30 ,visible:false},
                     {dataField:"userName"      ,headerText:"User Name"       ,width:120    ,height:30 }
                     ];
                     
var resop = {
//         rowIdField : "rnum",            
//         //editable : true,
//         groupingFields : ["reqstno", "staname"],
//         displayTreeOpen : true,
//         enableCellMerge : true,
//         //showStateColumn : false,
//         showBranchOnGrouping : false
        };

var paramdata;

var sstatus = [{"codeId": "44","codeName": "Pending"} , {"codeId": "5" ,"codeName": "Approved"} , {"codeId": "4" ,"codeName": "Completed"} ];

$(document).ready(function(){
    /**********************************
    * Header Setting
    **********************************/
    //paramdata
    doGetComboCodeId('/logistics/design/selectArtworkCategory.do',{grp:'cate'}, '','scate', 'A' , '');
    doGetComboCodeId('/logistics/design/selectArtworkCategory.do',{grp:'type'}, '','stype', 'A' , '');
    doDefCombo(sstatus, '' ,'sstatus', 'A', '');
    /**********************************
     * Header Setting End
     ***********************************/
    
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);
    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {
    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
    });
    
    AUIGrid.bind(listGrid, "ready", function(event) {
    });
    
    
});

//btn clickevent
$(function(){
    $('#search').click(function() {
        SearchListAjax();
    });
    $('#clear').click(function() {
    });
    $("#sttype").change(function(){
    });
    $('#insert').click(function(){
    });
});


function SearchListAjax() {
    
    var url = "/logistics/stocktransfer/StocktransferSearchList.do";
    var param = $('#searchForm').serializeJSON();
    Common.ajax("POST" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.data);
        
    });
}


</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>MISC</li>
    <li>Design</li>
    <li>Artwork Request</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Artwork List</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
    <ul class="right_btns">
      <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
      <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">

        <!-- menu setting -->
        <input type="hidden" name="CURRENT_MENU_CODE" value="${param.CURRENT_MENU_CODE}"/>
        <input type="hidden" name="CURRENT_MENU_FULL_PATH_NAME" value="${param.CURRENT_MENU_FULL_PATH_NAME}"/>
        <!-- menu setting -->
        <input type="hidden" name="rStcode" id="rStcode" />    
        <table summary="search table" class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">Application ID</th>
                    <td>
                        <input type="text" class="w100p" id="sappid" name="sappid">
                    </td>
                    <th scope="row">Category</th>
                    <td>
                        <select class="w100p" id="scate" name="scate"></select>
                    </td>
                    <th scope="row">Type</th>
                    <td>
                        <select class="w100p" id="stype" name="stype"></select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Org Code</th>
                    <td>
                        <input type="text" class="w100p" id="sorgcd" name="sorgcd">
                    </td>
                    <th scope="row">Grp Code</th>
                    <td >
                        <input type="text" class="w100p" id="sgrpcd" name="sgrpcd">
                    </td>
                    <th scope="row">Dept Code</th>
                    <td>
                        <input type="text" class="w100p" id="sdeptcd" name="sdeptcd">
                    </td>             
                </tr>
                
                <tr>
                    <th scope="row">Status</th>
                    <td>
                        <select class="w100p" id="sstatus" name="sstatus"></select>                        
                    </td>
                    <th scope="row">Requestor ID</th>
                    <td >
                        <input id="sreqid" name="sreqid" type="text" class="w100p">
                    </td>
                    <th scope="row">Requestor Name</th>
                    <td >
                        <input id="sreqnm" name="sreqnm" type="text" class="w100p">
                    </td>                
                </tr>
            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
            <li><p class="btn_grid"><a id="insert">INS</a></p></li>            
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:380px"></div>
        
    </section><!-- search_result end -->
</section>

