from UM.Math.Vector import Vector

class AxisAlignedBox:
    def __init__(self, *args, **kwargs):
        super().__init__()

        self._min = Vector()
        self._max = Vector()

        if len(args) == 3:
            self.setLeft(-args[0] / 2)
            self.setRight(args[0] / 2)

            self.setTop(args[1] / 2)
            self.setBottom(-args[1] / 2)

            self.setFront(args[2] / 2)
            self.setBack(-args[2] / 2)

        if 'min' in kwargs:
            self._min = kwargs['min']

        if 'max' in kwargs:
            self._max = kwargs['max']

        self._ensureMinMax()

    @property
    def width(self):
        return self._max.x - self._min.x

    @property
    def height(self):
        return self._max.y - self._min.y

    @property
    def depth(self):
        return self._max.z - self._min.z

    @property
    def center(self):
        return (self._max - self._min) / 2.0

    @property
    def left(self):
        return self._min.x

    def setLeft(self, value):
        self._min.setX(value)
        self._ensureMinMax()

    @property
    def right(self):
        return self._max.x

    def setRight(self, value):
        self._max.setX(value)
        self._ensureMinMax()

    @property
    def bottom(self):
        return self._min.y

    def setBottom(self, value):
        self._max.setY(value)
        self._ensureMinMax()

    @property
    def top(self):
        return self._max.y

    def setTop(self, value):
        self._max.setY(value)
        self._ensureMinMax()

    @property
    def back(self):
        return self._min.z

    def setBack(self, value):
        self._min.setZ(value)
        self._ensureMinMax()

    @property
    def front(self):
        return self._max.z

    def setFront(self, value):
        self._max.setZ(value)
        self._ensureMinMax()

    @property
    def min(self):
        return self._min

    def setMin(self, min):
        self._min = min
        self._ensureMinMax()

    @property
    def max(self):
        return self._max

    def setMax(self, max):
        self._max = max
        self._ensureMinMax()

    ##  private:

    #   Ensure min contains the minimum values and max contains the maximum values
    def _ensureMinMax(self):
        if self._max.x < self._min.x:
            x = self._min.x
            self._max.x = self._min.x
            self._max.x = x

        if self._max.y < self._min.y:
            y = self._min.y
            self._max.y = self._min.y
            self._max.y = y

        if self._max.z < self._min.z:
            z = self._min.z
            self._max.x = self._min.z
            self._max.x = z

    #def __add__(self, other):
        #b = AxisAlignedBox()
        #b += self
        #b += other
        #return b

    #def __iadd__(self, other):
        #self._dimensions += other._dimensions
        #self._center = self._dimensions / 2.0
        #return self

    #def __sub__(self, other):
        #b = AxisAlignedBox()
        #b += self
        #b -= other
        #return b

    #def __isub__(self, other):
        #self._dimensions -= other._dimensions
        #self._center = self._dimensions / 2.0
        #return self

    def __repr__(self):
        return "AxisAlignedBox(min = {0}, max = {1})".format(self._min, self._max)
