<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">
 // AUIGrid 생성 후 반환 ID
    var myGridID;   
    var gridValue;
    var newGridID;
        function fn_tabSize(){
            AUIGrid.resize(myGridID,1000,400); 
        }

    
        function createAUIGrid(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ {
                    dataField : "memId",
                    headerText : "memId",
                    width : 0
                }, {
                    dataField : "memType",
                    headerText : "memType",
                    width : 0
                }, {
                    dataField : "memberid1",
                    headerText : "memberid1",
                    width : 100
                }, {
                    dataField : "memCode",
                    headerText : "Member Code.",
                    width : 100
                }, {
                    dataField : "name",
                    headerText : "Member Name.",
                    width : 120
                }, {
                    dataField : "code",
                    headerText : "Status",
                    width : 120
                }, {
                    dataField : "",
                    headerText : "Upcode",
                    width : 20,
                    colSpan : 2,
                    renderer : {
                            type : "CheckBoxEditRenderer",
                            editable : true
                      }
                }, {
                    dataField : "",
                    width : 120,
                    colSpan : -1,
                    editRenderer : {// 셀 자체에 드랍다운리스트 출력하고자 할 때
                        type : "DropDownListRenderer",
                        list : ["IPhone 5S", "Galaxy S5", "IPad Air", "Galaxy Note3", "LG G3", "Nexus 10"]
                     }
                }, {
                    dataField : "status",
                    headerText : "",
                    width : 120,
                    renderer : {
                            type : "ButtonRenderer",
                            labelText : "Transfer",
                            onclick : function(rowIndex, columnIndex, value, item) {
                                alert("( " + rowIndex + ", " + columnIndex + " ) " + item.name + " 상세보기 클릭");
                            }
                     }
            
            }];
            
            var newColumn=[
                  {dataField:"0", headerText:"OrderNo"},
                  {dataField:"1", headerText:"Month"},
                  {dataField:"2", headerText:"Day"},
                  {dataField:"3", headerText:"Year"},
                  {dataField:"4", headerText:"RejectCode"}
            ];

            // 그리드 속성 설정
            var gridPros = {
                
                // 페이징 사용       
                usePaging : true,
                
                // 한 화면에 출력되는 행 개수 20(기본값:20)
                pageRowCount : 20,
                
                editable : true,
                
                showStateColumn : true, 
                
                displayTreeOpen : true,
                
                selectionMode : "singleRow",
                    
                headerHeight : 30,
                
                // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                skipReadonlyColumns : true,
                
                // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                wrapSelectionMove : true,
                
                // 줄번호 칼럼 렌더러 출력
                showRowNumColumn : true,
        
            };

                myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
/*                 newGridID = AUIGrid.create("#grid_wrap_new", newColumn, gridPros); */
    }
    
    

        </script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Member Promote/Demote Confirmation</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
<!--     <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_confirm()">CONFIRM</a></p></li> -->       
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->

<aside class="title_line"><!-- title_line start -->
<h2>Event Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Request No</th>
    <td>
    <span><c:out value="${promoInfo.reqstNo}"/></span>
    </td>
    <th scope="row">Request Status</th>
    <td>
    <span><c:out value="${promoInfo.name1}"/></span>
    </td>
    <th scope="row">Create At</th>
    <td>
    <span><c:out value="${promoInfo.c1}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Type</th>
    <td colspan="3"><span><c:out value="${promoInfo.codename1}"/></span></td>
    <th scope="row">Create By</th>
    <td><span><c:out value="${promoInfo.c6}"/></span></td>
</tr>
<tr>
    <th scope="row">Level</th>
    <td colspan="3">
	    <span>
	     <c:choose>
            <c:when test="${promoInfo.memLvlFrom == '0' && promoInfo.memLvlTo == '0'}">
                <c:out value="N/A"/>
            </c:when>
            <c:otherwise>
                <c:out value="( ${promoInfo.memLvlFrom}    -  ${promoInfo.memOrgDesc}) To ( ${promoInfo.memLvlTo}    - ${promoInfo.memorgdescription1} )"/>
            </c:otherwise>
           </c:choose>
	    </span>
    </td>
    <th scope="row">Update At</th>
    <td><c:out value="${promoInfo.c5}"/></td>
</tr>
<tr>
    <th scope="row">Superior</th>
    <td colspan="3">
	    <span>
	     <c:choose>
            <c:when test="${promoInfo.parentDeptCodeFrom == null && promoInfo.parentDeptCodeTo == null}">
                <c:out value="N/A"/>
            </c:when>
            <c:otherwise>
                <c:out value="( ${promoInfo.parentDeptCodeFrom}    - ${promoInfo.c3} ) To ( ${ promoInfo.parentDeptCodeTo}   - ${promoInfo.c4} )"/>
            </c:otherwise>
          </c:choose>
	    </span>
    </td>
    <th scope="row">Update By</th>
    <td><span><c:out value="${promoInfo.c6}"/></span></td>
</tr>
<tr>
    <th scope="row">Member Type</th>
    <td><span><c:out value="${promoInfo.codeName}"/></span></td>
    <th scope="row">Member Code</th>
    <td><span><c:out value="${promoInfo.memCode}"/></span></td>
    <th scope="row">Member NRIC</th>
    <td><span><c:out value="${promoInfo.nric}"/></span></td>
</tr>
<tr>
    <th scope="row">Member Name</th>
    <td colspan="3"><span><c:out value="${promoInfo.name}"/></span></td>
    <th scope="row">Team Code</th>
    <%-- <td><span><c:out value="${promoInfo.deptCodeFrom} +"To" + ${promoInfo.deptCodeTo}"/></span></td> --%>
</tr>
<tr>
    <th scope="row">Branch(To)</th>
    <td colspan="3">  <span><c:out value="${promoInfo.brdesc}"/></span> </td>
    
     <th scope="row">Event Apply Date</th>  
     <td>
        <span>
         <c:choose>
            <c:when test="${promoInfo.evtApplyDt == null}">
                <c:out value="N/A"/>
            </c:when>
            <c:otherwise>
                <c:out value="${promoInfo.evtApplyDt}"/>
            </c:otherwise>
          </c:choose>
        </span>
     </td>
    
    
</tr>
<tr>
    <th scope="row">Vacation Start Date</th>
    <td>
        <span>
         <c:choose>
            <c:when test="${promoInfo.vactStdDt == null}">
                <c:out value="N/A"/>
            </c:when>
            <c:otherwise>
                <c:out value="${promoInfo.vactStdDt}"/>
            </c:otherwise>
         </c:choose>
        </span>
    </td>
    <th scope="row">Vacation End Date</th>
    <td>
        <span>
         <c:choose>
            <c:when test="${promoInfo.vactEndDt == null}">
                <c:out value="N/A"/>
            </c:when>
            <c:otherwise>
                <c:out value="${promoInfo.vactEndDt}"/>
            </c:otherwise>
         </c:choose>
        </span>
    </td>
    <th scope="row">Replacement CT</th>
    <td>
        <span>
         <c:choose>
            <c:when test="${promoInfo.vactReplCt == null}">
                <c:out value="N/A"/>
            </c:when>
            <c:otherwise>
                <c:out value="${promoInfo.vactReplCt}"/>
            </c:otherwise>
         </c:choose>
        </span>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5"><span><c:out value="${promoInfo.rem}"/></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
