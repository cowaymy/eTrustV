<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>



<!-- 
####################################
AUIGrid Hompage     : http://www.auisoft.net/price.html
Grid Documentation  : http://www.auisoft.net/documentation/auigrid/index.html
####################################
 -->    
    <script type="text/javaScript" language="javascript">
    
 // AUIGrid 생성 후 반환 ID
    var myGridID;

    $(document).ready(function(){
        
        // AUIGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout);

        // cellClick event.
        AUIGrid.bind(myGridID, "cellClick", function( event ) {
            
        });
        
        fn_getSampleListAjax();

    });

    // AUIGrid 칼럼 설정
    // 데이터 형태는 다음과 같은 형태임,
    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
    var columnLayout = [ {
            dataField : "id",
            headerText : "id",
            width : 120
        }, {
            dataField : "name",
            headerText : "Name",
            width : 120
        }, {
            dataField : "description",
            headerText : "description",
            width : 120
        }, {
            dataField : "product",
            headerText : "Product",
            width : 120
        }, {
            dataField : "color",
            headerText : "Color",
            width : 120
        }, {
            dataField : "price",
            headerText : "Price",
            dataType : "numeric",
            style : "my-column",
            width : 120
        }, {
            dataField : "quantity",
            headerText : "Quantity",
            dataType : "numeric",
            width : 120
        }, {
            dataField : "date",
            headerText : "Date",
            width : 120,
            visible : false
        }];

    
    // ajax list 조회.
    function fn_getSampleListAjax() {        
        Common.ajax("GET", "/sample/selectJsonSampleList", $("#searchForm").serialize(), function(result) {
            console.log("성공.");
            console.log("data : " + result);
            AUIGrid.setGridData(myGridID, result);
        });
    }

    function fn_gridExport(type){

    	// type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    	GridCommon.exportTo("grid_wrap", type, "test");
    }
    
    </script>

        
        <div id="content_pop">
            <!-- 타이틀 -->
            <div id="title">
                <ul>
                    <li><img src="<c:url value='/resources/images/egovframework/example/title_dot.gif'/>" alt=""/><spring:message code="list.sample" /></li>
                </ul>
            </div>
            
            <form id="searchForm" method="get" action="">
                 id : <input type="text" id="sId" name="sId"/><br/>
                 name : <input type="text" id="sName" name="sName"/><br/>
                 
                 <input type="button" class="btn" onclick="javascript:fn_getSampleListAjax();" value="조회"/>
             </form>
            
            <!-- grid -->
            <div id="main">
                <div>
                    <!-- 에이유아이 그리드가 이곳에 생성됩니다. -->
                    <div id="grid_wrap" style="width:800px; height:300px; margin:0 auto;"></div>
                </div>
                
                <div class="desc_bottom">
                    <p id="selectionDesc">22</p>
                </div>
                
                <div class="desc_bottom">
                    <p><span onclick="javascript:fn_gridExport('xlsx');" class="btn">다운로드("xlsx", "csv", "txt", "xml", "json", "pdf", "object" 가능)</span></p><p></p>
                </div>
            </div>
        </div>
