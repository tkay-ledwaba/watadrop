from rest_framework.decorators import api_view
from rest_framework.response import Response
from api.models.menu import Menu

from api.serializers.menu_serializer import MenuSerializer

@api_view(['GET'])
def getMenu(request):
    menu = Menu.objects.all()
    serializer = MenuSerializer(menu, many=True)

    return Response(serializer.data)