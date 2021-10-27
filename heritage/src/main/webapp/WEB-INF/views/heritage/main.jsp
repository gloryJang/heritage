<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <!DOCTYPE HTML>
    <html>
        <head>
            <title>문화재 상세주소 서비스</title>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
               
            <link rel="stylesheet" href="/resources/assets/css/main.css" />
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

            <!-- Font Awesome -->
            <link
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css"
            rel="stylesheet"
            />
            <!-- Google Fonts -->
            <link
            href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap"
            rel="stylesheet"
            />
            <!-- MDB -->
            <link
            href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/3.6.0/mdb.min.css"
            rel="stylesheet"
            />

            <!-- MDB -->
            <script type="text/javascript"
            src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/3.6.0/mdb.min.js"
            ></script>

            <style>
                html, body{
                    height: 100%;
                    width: 100%;
                }

                ::-webkit-scrollbar {
                width: 10px;
                }
                
                ::-webkit-scrollbar-track {
                background: rgba(255,255,255,0);
                border-radius: 5px;;
                }
                
                ::-webkit-scrollbar-thumb {
                background: linear-gradient(#c2e59c, #64b3f4);
                border-radius: 5px;
                }

            </style>
            
        </head>
        <body class="is-preload">

            <!-- alert 창 디자인 -->
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@9"></script>

            <!-- Header -->
                <div id="header" style="width: 30%; float: left;">
    
                    <div class="top">
    
                        <hr style="color: #6bc010; height:2px; margin: 20px 30px 0px 30px;">

                        <div id="logo">
                            <h1 id="title"">문화재 상세주소 서비스</h1>
                            <p>Cultural Heritage Detailed Address Service</p>
                        </div>

                        <div id="search" style="margin: 0px 30px 0px 30px;"">
                            <div class="input-group rounded">
                                <input type="search" id="searchWord" class="form-control rounded" placeholder="문화재를 입력하세요. (예시 : 서울 숭례문)" aria-label="Search"
                                aria-describedby="search-addon" onkeyup="enterSearch()" style="border: 3px solid #2d80c4;"/>
                                </div>
                        </div>

                        <hr style="color: #6bc010; height:2px; margin: 20px 30px 0px 30px;">

                        <div  style="margin: 20px;">
                            <ul id="heritageList" class="list-group">
                            </ul>
                        </div>
    
                    </div>
  
                </div>
    
            <!-- Main -->
                <div id="main" style="height: 100%; width: 70%; float:right; margin:0;">
                </div> 

                <script type="text/javascript" type="text/javascript">
                    $(document).ready(function(){

                        $('#buttonSearch').click(function(){
                            searchHeritage();
                        });

                        $('#heritageList').on('click', '.list-group-item', function(e) {
                            var selectedItem = $(this).text().split('   ')[0];
                            heritageOnMap(selectedItem);
                        });
                    });

                    var polygons = [];
                    var markers = [];

                    let enterSearch
                    (function($){
                        enterSearch = () => {
                            if(window.event.keyCode == 13){
                                searchHeritage();
                            }
                        }
                    })(jQuery)

                function searchHeritage()
                {
                    //검색어를 입력하지 않았을 때
                    if($('#searchWord').val().trim() == 0)
                    {
                        Swal.fire('검색어를 입력하세요.');
                        return
                    }

                    $('#heritageList').children().remove();

                    //검색결과 가져오기
                    $.ajax({
                        url: "loadList",
                        type: "GET",
                        data: {name: $('#searchWord').val().trim()},
                        dataType:"JSON",
                        success: function(data){
                            showHeritageList(data);
                            makemarkers(data);
                        },
                        error: function(){
                            alert("error"); 
                        }
                    });
                }
                
                function makemarkers(data)
                {
                    for(var i=0; i<data.length; i++)
                    {
                        var dataLatlng = data[i]['CENTER'].split('[')[1].split(']')[0].trim();
                        var markerPosition = new kakao.maps.LatLng(dataLatlng.split(',')[1].trim(), dataLatlng.split(',')[0].trim());
                        markers.push(new kakao.maps.Marker({
                            position: markerPosition
                        }))
                        markers[markers.length-1].setMap(map)
                    }
                }

                //검색 결과 리스트 보여주기
                function showHeritageList(data)
                {
                    var heritageList = $('#heritageList');

                    for (var i=0; i<data.length; i++)
                    {
                        heritageList.append("<li id=\"heritageItem\" class=\"list-group-item list-group-item-action\" style=\" text-align:left;\">"
                            + "<div><span id=\"heritageName\" style=\"color: #1679ca; font-size: 1.1em; font-weight:bold;\">" + data[i]['HERITAGENAME']
                            + "</span><span style=\"color: black; font-size:0.8em\">   " + data[i]['HERITAGETYPE'] + "</span></div>"
                            + "<div><span style=\"color: darkgray; font-size:0.8em\">" + data[i]['ADDRESS'] + "</span></div></li>"
                        );                    
                    }                      

                }

                function heritageOnMap(selectedItem)
                {
                    //하나의 결과 가져오기
                    $.ajax({
                        url: "loadOneHeritage",
                        type: "GET",
                        data: {name: selectedItem},
                        dataType:"JSON",
                        success: function(data){
                            focusTo(data);
                        },
                        error: function(){
                            alert("error"); 
                        }
                    });
                }

                function focusTo(data)
                {
                    //지도에 있는 도형 지우기
                    if(polygons != null)
                    {
                    for(var i=0; i<polygons.length; i++)
                    {
                        polygons[i].setMap(null);
                    }
                    }
                    //지도에 있는 마커 지우기
                    if(markers != null)
                    {
                    for(var i=0; i<markers.length; i++)
                    {
                        markers[i].setMap(null);
                    }
                    }

                    var figureType = data[0]['FIGURETYPE'];
                    var center = data[0]['CENTER'];
                    var heritageCoordinate = String(data[0]['COORDINATES']);
                    var coordinateGroup;

                    //멀티폴리곤일 경우
                    if(figureType == "MultiPolygon")
                    {
                        //[ 삭제
                        heritageCoordinate = heritageCoordinate.substr(1, heritageCoordinate.length-1).trim();
                        //] 삭제
                        heritageCoordinate = heritageCoordinate.substr(0, heritageCoordinate.length-1).trim();

                        var groupPolygon = heritageCoordinate.split("[ [ [");

                        for(var i=1; i<groupPolygon.length; i++)
                        {
                            groupPolygon[i] = "[ [ [" + groupPolygon[i];
                            dividePolygon(groupPolygon[i]);
                        }
                    }
                    //일반폴리곤일 경우
                    else if(figureType == "Polygon")
                    {
                        dividePolygon(heritageCoordinate);
                    }

                    //화면 이동하기
                    moveTo(center);
                }

                //일반폴리곤과 구멍있는폴리곤 나누기
                function dividePolygon(whichPolygon)
                {
                    //일반폴리곤이라면...
                    if(whichPolygon.split("[ [").length == 2)
                    {
                        whichPolygon = whichPolygon.substr(4, whichPolygon.length-4).trim();
                        whichPolygon = whichPolygon.substr(0, whichPolygon.length-4).trim();
                        //좌표로만 되어 있는 상태
                        
                        var normalPolygon = whichPolygon.split("[");
                        for (var i = 1; i < normalPolygon.length; i++)
                        {
                            normalPolygon[i] = normalPolygon[i].split(']')[0].trim();
                        }
                        drawNormalPolygon(normalPolygon);                    
                    }
                    //구멍있는폴리곤이라면
                    else if (whichPolygon.split("[ [").length == 3)
                    {
                        whichPolygon = whichPolygon.substr(1, whichPolygon.length-1).trim();
                        var holePolygon = whichPolygon.split("[ [ ");

                        for (var i = 1; i < holePolygon.length; i++)
                        {
                            holePolygon[i] = "[" + holePolygon[i].split(" ] ]")[0] + "]";
                        }

                        var backGroup = holePolygon[1].split("[");
                        var holeGroup = holePolygon[2].split("[");

                        for(var i=1; i<backGroup.length; i++)
                        {
                            backGroup[i] = backGroup[i].split(']')[0].trim();
                        }
                        for(var i=1; i<holeGroup.length; i++)
                        {
                            holeGroup[i] = holeGroup[i].split(']')[0].trim();
                        }

                        drawHolePolygon(backGroup, holeGroup);
                    }
                 }

                function drawNormalPolygon(normalPolygon)
                {
                    var polygonPath = [];

                        for(var i=1; i < normalPolygon.length; i++)
                        {
                            polygonPath.push(new kakao.maps.LatLng(normalPolygon[i].split(",")[1].trim(), normalPolygon[i].split(",")[0].trim()));
                        }
                                            
                    // 지도에 표시할 다각형을 생성합니다
                    polygons.push(new kakao.maps.Polygon({
                        path:polygonPath, // 그려질 다각형의 좌표 배열입니다
                        strokeWeight: 3, // 선의 두께입니다
                        strokeColor: '#cf1717', // 선의 색깔입니다
                        strokeOpacity: 0.8, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
                        strokeStyle: 'longdash', // 선의 스타일입니다
                        fillColor: '#f0c6c5', // 채우기 색깔입니다
                        fillOpacity: 0.7 // 채우기 불투명도 입니다
                    }));
                    
                    // 지도에 다각형을 표시합니다
                    polygons[polygons.length-1].setMap(map);
                }

                function drawHolePolygon(backGroup, holeGroup)
                {
                    var path = [];
                    var hole = [];

                    for(var i=1; i < backGroup.length; i++)
                    {
                        path.push(new kakao.maps.LatLng(backGroup[i].split(",")[1].trim(), backGroup[i].split(",")[0].trim()));
                    }

                    for(var i=1; i < holeGroup.length; i++)
                    {
                        hole.push(new kakao.maps.LatLng(holeGroup[i].split(",")[1].trim(), holeGroup[i].split(",")[0].trim()));
                    }
                                        
                    // 지도에 표시할 다각형을 생성합니다
                    polygons.push(new kakao.maps.Polygon({
                    path: [path, hole], // 그려질 다각형의 좌표 배열입니다
                    strokeWeight: 3, // 선의 두께입니다
                    strokeColor: '#cf1717', // 선의 색깔입니다
                    strokeOpacity: 0.8, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
                    strokeStyle: 'longdash', // 선의 스타일입니다
                    fillColor: '#f0c6c5', // 채우기 색깔입니다
                    fillOpacity: 0.7 // 채우기 불투명도 입니다
                    }));

                    // 지도에 다각형을 표시합니다
                    polygons[polygons.length-1].setMap(map);
                }

                function moveTo(center)
                {
                    //[ 삭제
                    center = center.substr(1, center.length-1).trim();
                        //] 삭제
                    center = center.substr(0, center.length-1).trim();

                    var moveLatLon = new kakao.maps.LatLng(center.split(",")[1].trim(), center.split(",")[0].trim()) // 지도의 중심좌표
                    map.panTo(moveLatLon);
                }
                    
                 </script> 
                
                <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=6c83b812ba7b8d29c856df5598527c46"></script>
                <script>
                var mapContainer = document.getElementById('main'), // 지도를 표시할 div 
                    mapOption = { 
                        center: new kakao.maps.LatLng(37.579512, 126.977019), // 지도의 중심좌표
                        level: 3 // 지도의 확대 레벨
                    };  
                
                var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

                /*
                // 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성합니다
                var mapTypeControl = new kakao.maps.MapTypeControl();
                // kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOPRIGHT는 오른쪽 위를 의미합니다
                map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
                */

                // 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
                var zoomControl = new kakao.maps.ZoomControl();
                map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

                // 지도가 확대 또는 축소되면 마지막 파라미터로 넘어온 함수를 호출하도록 이벤트를 등록합니다
                kakao.maps.event.addListener(map, 'zoom_changed', function() {        
                    
                    // 지도의 현재 레벨을 얻어옵니다
                    var level = map.getLevel();                    
                });               
                </script>

                <script src="/resources/assets/js/jquery.min.js"></script>
                <script src="/resources/assets/js/jquery.scrolly.min.js"></script>
                <script src="/resources/assets/js/jquery.scrollex.min.js"></script>
                <script src="/resources/assets/js/browser.min.js"></script>
                <script src="/resources/assets/js/breakpoints.min.js"></script>
                <script src="/resources/assets/js/util.js"></script>
                <script src="/resources/assets/js/main.js"></script>

        </body>
    </html>